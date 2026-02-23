# genai-xskills.ai

AI video generation pipeline for Claude Code. Go from concept to finished video project with storyboard planning, keyframe image generation, video synthesis, and an HTML gallery of all assets.

Powered by the [xskills.ai](https://xskills.ai) API.

## Prerequisites

- **XSKILL_API_KEY**: Set as an environment variable. Get your key from xskills.ai.
- **Python 3**: Required by the generation scripts for JSON handling.
- **curl**: Used for API requests.

## Skills

| Skill | Purpose |
|-|-|
| `create-storyboard` | Plan a video as timed shots with camera, scene, action, and image prompts |
| `create-image` | Generate keyframe images via xskills.ai (Flux 2 Flash, Seedream, etc.) |
| `create-video` | Generate video from images/prompts via xskills.ai (Seedance 2.0, Sora 2, etc.) |
| `video-pipeline` | Orchestrate the full workflow: storyboard -> images -> video -> gallery |

## Quick Start

Install the plugin, then ask Claude:

- "Create a storyboard for a 10-second product video"
- "Generate keyframe images from my storyboard"
- "Create a video from these images using Seedance"
- "Run the full video pipeline for a coffee brand ad"

Or start at any step -- each skill works independently.

## Workflow

```
1. Storyboard  -->  2. Images  -->  3. Video  -->  4. Gallery
```

You can enter at any step. The `video-pipeline` skill orchestrates all steps and creates a project folder with all assets and an HTML gallery.

## Supported Models

### Image Generation

| Model | ID | Cost |
|-|-|-|
| Flux 2 Flash | `fal-ai/flux-2/flash` | 2 credits/image |
| Seedream 4.5 | `st-ai/seedream-4.5` | varies |
| Nano Banana Pro | `st-ai/nano-banana-pro` | varies |
| Gemini 3 Pro | `st-ai/gemini-3-pro-image` | varies |

### Video Generation

| Model | ID | Cost |
|-|-|-|
| Seedance 2.0 Fast | `st-ai/super-seed2` | ~20 credits/sec |
| Sora 2 | `fal-ai/sora-2/text-to-video` | 40 credits/sec |
| WAN 2.6 | varies | varies |
| Hailuo 2.3 | varies | varies |

## Project Output

The pipeline creates a project folder:

```
my-project/
  storyboard.md
  images/
    shot-01.png
    shot-02.png
  video/
    output.mp4
  gallery.html
  manifest.json
```

Open `gallery.html` in a browser to view the video and browse keyframe images in a carousel.

## API Reference

All models use the same API pattern:

- **Create task**: `POST https://api.sutui.cc/api/v3/tasks/create`
- **Query task**: `POST https://api.sutui.cc/api/v3/tasks/query`
- **Auth**: `Authorization: Bearer $XSKILL_API_KEY`
- **Model docs**: `https://api.xskill.ai/api/v3/models/<model-id>/llms.txt`

## License

MIT
