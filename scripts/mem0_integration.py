import sys
import os
import argparse
import json

def load_env():
    """Load .env.local file for environment variable overrides."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    env_file = os.path.join(project_root, ".env.local")
    if os.path.isfile(env_file):
        with open(env_file) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    k, v = line.split("=", 1)
                    os.environ.setdefault(k.strip(), v.strip())

def get_memory_config():
    """Load env vars and return (Memory, user_id) tuple."""
    from mem0 import Memory
    
    load_env()
    
    # Read from env vars with hardcoded defaults for backward compatibility
    collection_name = os.environ.get("MEM0_COLLECTION", "mystudiochannel_memories")
    user_id = os.environ.get("MEM0_USER_ID", "msc")
    qdrant_folder = os.environ.get("MEM0_QDRANT_PATH", "").replace("%USERPROFILE%", os.path.expanduser("~"))
    
    # Ensure local directory exists
    user_home = os.path.expanduser("~")
    mem0_dir = os.path.join(user_home, ".mem0")
    os.makedirs(mem0_dir, exist_ok=True)
    
    if not qdrant_folder:
        qdrant_folder = os.path.join(mem0_dir, "qdrant")
    
    config = {
        "vector_store": {
            "provider": "qdrant",
            "config": {
                "collection_name": collection_name,
                "path": qdrant_folder,
                "embedding_model_dims": 384,
            }
        },
        "llm": {
            "provider": "lmstudio",
            "config": {
                "model": os.environ.get("MEM0_LM_MODEL", os.environ.get("HERMES_LM_MODEL", "qwen3-4b-instruct-2507")),
                "lmstudio_base_url": "http://127.0.0.1:1234/v1",
                "temperature": 0.1,
                "max_tokens": 512,
                "lmstudio_response_format": {"type": "json_schema", "json_schema": {"type": "object", "schema": {}}}
            }
        },
        "embedder": {
            "provider": "huggingface",
            "config": {
                "model": "multi-qa-MiniLM-L6-cos-v1"
            }
        }
    }
    return Memory.from_config(config), user_id

def main():
    parser = argparse.ArgumentParser(description="MyStudioChannel Mem0 Integration layer")
    parser.add_argument("--action", choices=["add", "search", "list", "delete", "get_all"], required=True, help="Action to perform")
    parser.add_argument("--text", help="Text to add (required for add action)")
    parser.add_argument("--query", help="Query to search (required for search action)")
    parser.add_argument("--id", help="Memory ID to delete (required for delete action)")
    parser.add_argument(
        "--infer",
        action="store_true",
        default=False,
        help="Use LLM fact extraction on add (default: infer=False for direct storage)",
    )
    args = parser.parse_args()
    
    # LM Studio check for search and infer=True adds.
    # Preflight check is handled by msc-mem0-preflight.ps1 before this script is invoked.
    # We do NOT re-check here to avoid a race condition where LM Studio is momentarily busy.
    try:
        m, uid = get_memory_config()
        if args.action == "add":
            if not args.text:
                print(json.dumps({"success": False, "error": "--text is required for add action"}))
                sys.exit(1)
            res = m.add(args.text, user_id=uid, infer=args.infer)
            results = res.get("results", []) if isinstance(res, dict) else []
            if not results:
                print(json.dumps({
                    "success": False,
                    "error": "Memory add returned no results. Try infer=False (default) or shorten text.",
                    "data": res,
                }))
                sys.exit(1)
            print(json.dumps({"success": True, "data": res}))
            
        elif args.action == "search":
            if not args.query:
                print(json.dumps({"success": False, "error": "--query is required for search action"}))
                sys.exit(1)
            res = m.search(args.query, filters={"user_id": uid})
            print(json.dumps({"success": True, "data": res}))

        elif args.action == "list" or args.action == "get_all":
            res = m.get_all(filters={"user_id": uid})
            print(json.dumps({"success": True, "data": res}))

        elif args.action == "delete":
            if not args.id:
                print(json.dumps({"success": False, "error": "--id is required for delete action"}))
                sys.exit(1)
            res = m.delete(args.id)
            print(json.dumps({"success": True, "data": res}))
            
    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}))
        sys.exit(1)

if __name__ == "__main__":
    main()
