---
name: create-image
description: This skill should be used when the user asks to "generate images", "create keyframes", "generate keyframe images", "make reference images for video", "generate images from storyboard", or wants to create images using the xskills.ai API. Handles image generation via multiple models (Flux 2 Flash, Seedream, Nano Banana Pro, Gemini, Jimeng) with automatic task polling.
---

# Create Image

Generate images using the xskills.ai API. Primarily used to create keyframe/reference images from storyboard shot prompts, but also works for standalone image generation.

## API Overview

- **Base URL**: `https://api.sutui.cc/api/v3`
- **Auth**: `Authorization: Bearer $XSKILL_API_KEY`
- **Pattern**: Create task -> poll status -> get result URLs
- **Model docs**: `https://api.xskill.ai/api/v3/models/<model-id>/llms.txt`

## Quick Start

To generate an image, use the `scripts/generate-image.sh` script:

```bash
bash "<skill_path>/scripts/generate-image.sh" \
  "A sunset over the ocean, golden light on calm waters" \
  "fal-ai/flux-2/flash" \
  "landscape_4_3" \
  1
```

Arguments: `<prompt> [model] [image_size] [num_images]`

The script reads `XSKILL_API_KEY` from the environment, creates the task, polls until completion, and outputs the result image URLs.

## Recommended Models

| Model | ID | Cost | Best For |
|-|-|-|-|
| Flux 2 Flash | `fal-ai/flux-2/flash` | 2 credits/image | Fast drafts, general purpose (default) |
| Seedream 4.5 | `st-ai/seedream-4.5` | varies | High quality, text rendering |
| Nano Banana Pro | `st-ai/nano-banana-pro` | varies | Stylized, illustration |
| Gemini 3 Pro | `st-ai/gemini-3-pro-image` | varies | Photorealistic |
| Jimeng 4.5 Pro | `st-ai/jimeng-4.5-pro` | varies | Chinese-optimized |

Default to **Flux 2 Flash** for cost-efficiency. Use Seedream or Gemini for higher quality when the user requests it.

For detailed model parameters and capabilities, see `references/image-models.md`.

## Workflow: Storyboard to Keyframes

When generating images from a storyboard:

1. Read the storyboard file to extract shot image prompts
2. Confirm with the user: which model, which shots, any modifications to prompts
3. Generate one image per shot using the image prompt from each shot
4. Present the image URLs to the user for review
5. Save the URLs alongside the storyboard (append to the storyboard file or save as a separate manifest)

Track all generated image URLs -- they are needed by the `create-video` skill as `image_files` input.

## API Request Format

```json
{
  "model": "fal-ai/flux-2/flash",
  "params": {
    "prompt": "image description",
    "image_size": "landscape_4_3",
    "num_images": 1
  }
}
```

### Image Size Options

Common presets: `landscape_4_3`, `landscape_16_9`, `portrait_3_4`, `portrait_9_16`, `square`, `square_hd`

Match the image size to the storyboard's aspect ratio.

### Response Flow

Create returns `{code: 200, data: {task_id, price}}`.

Query with the task_id returns `{code: 200, data: {status, result: {output: {images: [urls]}}}}`.

Status values: `completed`, `success` (done), `failed`, `error` (terminal).

## Image Editing Mode

Some models (Flux 2 Flash, Seedream, Nano Banana Pro) support image editing. Pass existing image URLs via `image_urls` in params to enter edit mode:

```json
{
  "model": "fal-ai/flux-2/flash",
  "params": {
    "prompt": "change the sky to sunset colors",
    "image_urls": ["https://existing-image-url.jpg"],
    "image_size": "landscape_4_3"
  }
}
```

## Cost Awareness

Always inform the user of the estimated credit cost before generating. Flux 2 Flash costs 2 credits per image. For a 3-shot storyboard, that is 6 credits total.

When generating multiple images, process them sequentially and report progress after each.
