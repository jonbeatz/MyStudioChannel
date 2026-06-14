import os
import sys
from PIL import Image, ImageDraw, ImageFont

def create_grid():
    base_dir = "D:\\Cursor_Projectz\\MyStudioChannel\\public\\media\\comparison"
    img_paths = {
        "Hugging Face FLUX.1-schnell (Remote)": os.path.join(base_dir, "hf-flux-schnell.png"),
        "FLUX.1-dev (HF API, Highest Quality)": os.path.join(base_dir, "flux-1-dev.png"),
        "SDXL Turbo (Local GGUF)": os.path.join(base_dir, "sdxl-base-refiner.png"),
        "Stable Diffusion 1.5 (Local Checkpoint)": os.path.join(base_dir, "realistic-vision.png")
    }

    # Verify all files exist
    loaded_imgs = []
    labels = []
    for label, path in img_paths.items():
        if not os.path.exists(path):
            print(f"Error: Image {path} not found.")
            sys.exit(1)
        try:
            img = Image.open(path).convert("RGB")
            loaded_imgs.append(img)
            labels.append(label)
        except Exception as e:
            print(f"Error loading {path}: {e}")
            sys.exit(1)

    # Resize all to 1024x1024 for consistent, high-res layout
    target_size = (1024, 1024)
    resized_imgs = [img.resize(target_size, Image.Resampling.LANCZOS) for img in loaded_imgs]

    # Grid details: 2x2 grid
    # Each cell is 1024x1024
    # Border of 20px around and between cells
    cell_size = 1024
    margin = 30
    grid_w = margin * 3 + cell_size * 2
    grid_h = margin * 3 + cell_size * 2

    # Create background canvas (elegant SaaS dark neutral slate color)
    bg_color = (18, 18, 24) # NovaMira dark neutral
    grid_img = Image.new("RGB", (grid_w, grid_h), bg_color)
    draw = ImageDraw.Draw(grid_img)

    # Load font or fallback to default
    try:
        # Try finding a clean sans-serif system font
        font_path = "C:\\Windows\\Fonts\\arialbd.ttf"
        font_title = ImageFont.truetype(font_path, 42)
        font_sub = ImageFont.truetype(font_path, 28)
    except IOError:
        font_title = ImageFont.load_default()
        font_sub = ImageFont.load_default()

    # Positions for 2x2 layout
    positions = [
        (margin, margin),                               # Top-Left
        (margin * 2 + cell_size, margin),                # Top-Right
        (margin, margin * 2 + cell_size),                # Bottom-Left
        (margin * 2 + cell_size, margin * 2 + cell_size) # Bottom-Right
    ]

    # Brand colors
    accent_color = (245, 184, 65) # NovaMira Gold: #F5B841
    text_color = (255, 255, 255)
    card_bg_color = (0, 0, 0, 160) # Semi-transparent black overlay

    for i, (x, y) in enumerate(positions):
        img = resized_imgs[i]
        # Paste image
        grid_img.paste(img, (x, y))

        # Draw a beautiful borders around each image frame
        # Gold for local, white/silver for remote
        border_color = accent_color if "Local" in labels[i] else (200, 220, 255)
        # Draw 5px border
        for b in range(6):
            draw.rectangle([x-b, y-b, x+cell_size+b, y+cell_size+b], outline=border_color)

        # Draw transparent banner for label overlay
        overlay = Image.new('RGBA', (cell_size, 100), (0, 0, 0, 180))
        grid_img.paste(overlay, (x, y + cell_size - 100), overlay)

        # Draw label text
        draw.text((x + 30, y + cell_size - 75), labels[i], fill=accent_color if "Local" in labels[i] else text_color, font=font_title)

    # Save final grid
    output_grid_path = os.path.join(base_dir, "comparison-grid.png")
    grid_img.save(output_grid_path, "PNG")
    print(f"Success: Comparison grid saved to {output_grid_path}")

if __name__ == "__main__":
    create_grid()
