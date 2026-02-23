---
name: create-video
description: This skill should be used when the user asks to "generate a video", "create a video from images", "make a video", "generate video from keyframes", "use seedance to make a video", "create video with sora", or wants to submit images and prompts to the xskills.ai API for AI video generation. Supports multiple video models including Seedance 2.0, Sora 2, WAN 2.6, Hailuo, and VIDU.
---

# Create Video

Generate AI video using the xskills.ai API. Supports text-to-video and image-to-video workflows with multiple model options.

## API Overview

- **Base URL**: `https://api.sutui.cc/api/v3`
- **Auth**: `Authorization: Bearer $XSKILL_API_KEY`
- **Pattern**: Create task -> poll status -> get result URLs
- **Model docs**: `https://api.xskill.ai/api/v3/models/<model-id>/llms.txt`

## Quick Start

To generate a video, use the `scripts/generate-video.sh` script:

```bash
bash "<skill_path>/scripts/generate-video.sh" \
  "st-ai/super-seed2" \
  "A hiker walks through a mountain valley at sunrise" \
  "16:9" \
  5 \
  "https://img1.jpg" "https://img2.jpg"
```

Arguments: `<model> <prompt> [ratio] [duration] [image_urls...]`

The script reads `XSKILL_API_KEY` from the environment, creates the task, polls until completion, and outputs the result video URL.

## Recommended Models

| Model | ID | Type | Cost | Best For |
|-|-|-|-|-|
| Seedance 2.0 Fast | `st-ai/super-seed2` | i2v/t2v | 20 credits/sec (with video ref) | Image-to-video with keyframes (default) |
| Sora 2 | `fal-ai/sora-2/text-to-video` | t2v | 160+ credits | High quality text-to-video |
| WAN 2.6 | varies | i2v/t2v | varies | Reference-based, subject consistency |
| Hailuo 2.3 | varies | i2v/t2v | varies | Fast generation |
| VIDU Q3 | varies | i2v | varies | Image-to-video |

Default to **Seedance 2.0 Fast** for image-to-video workflows. Use Sora 2 for pure text-to-video when no keyframes are available.

For detailed model parameters, see `references/video-models.md`.

## Image-to-Video Workflow (Seedance 2.0)

This is the primary workflow when coming from `create-image` with keyframes.

### Seedance 2.0 Request Format

```json
{
  "model": "st-ai/super-seed2",
  "params": {
    "model": "seedance_2.0_fast",
    "prompt": "Scene description with @image_file_1 reference",
    "functionMode": "omni_reference",
    "ratio": "16:9",
    "duration": 5,
    "image_files": ["https://keyframe1.jpg", "https://keyframe2.jpg"]
  }
}
```

### Key Seedance Parameters

| Param | Options | Notes |
|-|-|-|
| `params.model` | `seedance_2.0_fast`, `seedance_2.0` | Fast is cheaper, standard is higher quality |
| `functionMode` | `omni_reference`, `first_last_frames` | Omni for reference images, first/last for start+end frames |
| `ratio` | `21:9`, `16:9`, `4:3`, `1:1`, `3:4`, `9:16` | Match storyboard aspect ratio |
| `duration` | 4-15 seconds | Longer = more credits |
| `image_files` | Up to 9 URLs | Keyframe images for visual reference |
| `video_files` | Up to 3 URLs, max 15s total | Optional video references |
| `audio_files` | Up to 3 URLs | Optional audio to sync |

### Image References in Prompt

Reference uploaded images in the prompt using `@image_file_N` syntax:

```
A hiker walks along a mountain trail at sunrise, matching the scene in @image_file_1,
transitioning to the coffee close-up in @image_file_2
```

## Text-to-Video Workflow (Sora 2)

When no keyframe images are available:

```json
{
  "model": "fal-ai/sora-2/text-to-video",
  "params": {
    "prompt": "A beautiful sunset over the ocean, golden light on calm waters",
    "duration": 4,
    "aspect_ratio": "16:9",
    "resolution": "720p",
    "model": "sora-2"
  }
}
```

## Image Upload Requirement

The API requires **public URLs** for image_files, not local file paths. If images are local:

1. If images were generated via `create-image`, the result URLs are already hosted -- use those directly
2. For local files, upload them to a public host first to get URLs (e.g., using an image upload service or CDN)

## Response Flow

Create returns: `{code: 200, data: {task_id, price}}`

Poll with task_id. Video generation takes 30-120 seconds depending on model and duration.

Query returns: `{code: 200, data: {status, result: {output: {images: [video_urls]}}}}`

Note: Video URLs are returned in the `images` array despite being video files.

## Cost Awareness

Video generation is significantly more expensive than images. Always inform the user:

| Model | Duration | Estimated Cost |
|-|-|-|
| Seedance 2.0 Fast (no video ref) | 5s | ~50 credits |
| Seedance 2.0 Fast (with video ref) | 5s | ~100 credits |
| Seedance 2.0 Standard | 5s | ~200 credits |
| Sora 2 | 4s | ~160 credits |
| Sora 2 | 8s | ~320 credits |

Get user confirmation before submitting, especially for longer durations or standard quality.
