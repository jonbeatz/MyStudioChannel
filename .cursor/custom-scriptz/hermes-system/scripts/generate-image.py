#!/usr/bin/env python3
# MyStudioChannel Free Image Generation Layer (FLUX.1-schnell)
# Usage: python scripts/generate-image.py --prompt "..." [--output "output.png"]

import os
import sys
import json
import argparse
from pathlib import Path

def get_hf_token(project_root):
    # Try reading from environment variable first
    if "HF_TOKEN" in os.environ and os.environ["HF_TOKEN"].strip():
        return os.environ["HF_TOKEN"].strip()
    
    # Otherwise read from .env.local
    env_local_path = project_root / ".env.local"
    if env_local_path.exists():
        with open(env_local_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line.startswith("HF_TOKEN="):
                    # Extract value and strip double/single quotes
                    token = line.split("=", 1)[1].strip()
                    if (token.startswith('"') and token.endswith('"')) or (token.startswith("'") and token.endswith("'")):
                        token = token[1:-1].strip()
                    return token
    return None

def main():
    parser = argparse.ArgumentParser(description="Generate images locally using Hugging Face Serverless FLUX.1")
    parser.add_argument("--prompt", required=True, type=str, help="Text description of the image to generate")
    parser.add_argument("--model", type=str, default="black-forest-labs/FLUX.1-schnell", help="HF model name to use")
    parser.add_argument("--output", type=str, default="", help="Optional specific output path for the PNG file")
    parser.add_argument("--width", type=int, default=1024, help="Image width (optional)")
    parser.add_argument("--height", type=int, default=1024, help="Image height (optional)")
    args = parser.parse_args()

    # Define paths relative to this script
    script_dir = Path(__file__).resolve().parent
    project_root = script_dir.parent

    # Retrieve HF Token
    hf_token = get_hf_token(project_root)
    if not hf_token:
        print(json.dumps({
            "success": False,
            "error": "HF_TOKEN not found. Please add HF_TOKEN=hf_... to your .env.local file."
        }))
        sys.exit(1)

    # Resolve output path
    output_path = args.output
    if not output_path:
        # Default fallback if no path passed
        import datetime
        timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        media_dir = project_root / "public" / "media"
        media_dir.mkdir(parents=True, exist_ok=True)
        output_path = os.path.abspath(str(media_dir / f"generated-{timestamp}.png"))
    else:
        output_path_obj = Path(output_path)
        output_path_obj.parent.mkdir(parents=True, exist_ok=True)
        output_path = os.path.abspath(output_path)

    try:
        from huggingface_hub import InferenceClient
        
        # Initialize client with our token
        client = InferenceClient(api_key=hf_token)

        # Generate image using Black Forest Labs model
        image = client.text_to_image(
            prompt=args.prompt,
            model=args.model,
            width=args.width,
            height=args.height
        )

        # Save generated PIL image object as PNG
        image.save(output_path, "PNG")

        print(json.dumps({
            "success": True,
            "file_path": output_path,
            "prompt": args.prompt
        }))
        sys.exit(0)

    except ImportError:
        print(json.dumps({
            "success": False,
            "error": "Required Python libraries are missing. Please run 'pip install huggingface_hub pillow'."
        }))
        sys.exit(1)
    except Exception as e:
        print(json.dumps({
            "success": False,
            "error": str(e)
        }))
        sys.exit(1)

if __name__ == "__main__":
    main()
