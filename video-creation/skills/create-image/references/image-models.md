# Image Generation Models -- Detailed Reference

## Flux 2 Flash

- **Model ID**: `fal-ai/flux-2/flash`
- **Task type**: t2i (text-to-image), also supports editing when `image_urls` provided
- **Cost**: 2 credits per image

### Parameters

| Param | Type | Required | Default | Description |
|-|-|-|-|-|
| `prompt` | string | Yes | -- | Image generation or editing prompt |
| `image_urls` | array | No | -- | Input image URLs (1-4). Enables edit mode. |
| `image_size` | string | No | `landscape_4_3` | Size preset |
| `num_images` | integer | No | 1 | Number of images to generate |
| `guidance_scale` | number | No | 2.5 | How closely to follow the prompt |
| `seed` | integer | No | random | For reproducible results |
| `enable_prompt_expansion` | boolean | No | false | Let model expand the prompt |
| `output_format` | string | No | `png` | Output format |
| `enable_safety_checker` | boolean | No | true | Safety filter |

### Image Size Presets

`landscape_4_3`, `landscape_16_9`, `portrait_3_4`, `portrait_9_16`, `square`, `square_hd`

### Notes

- Cheapest option at 2 credits/image
- Good text rendering
- Edit mode: provide `image_urls` to modify existing images
- Fast generation (~10-15 seconds)

---

## Flux 2 Flash Edit

- **Model ID**: `fal-ai/flux-2/flash/edit`
- **Task type**: i2i (image-to-image editing)
- **Cost**: 2 credits per image

Dedicated editing variant. Same parameters as Flux 2 Flash but `image_urls` is required.

---

## Seedream 4.5

- **Model ID**: `st-ai/seedream-4.5` (text-to-image), `st-ai/seedream-4.5-edit` (editing)
- **Task type**: t2i / i2i
- **Cost**: Check model docs

### Key Parameters

| Param | Type | Required | Default | Description |
|-|-|-|-|-|
| `prompt` | string | Yes | -- | Generation prompt |
| `image_size` | string | No | varies | Size preset |
| `num_images` | integer | No | 1 | Number of images |

Higher quality than Flux 2, especially for photorealistic outputs.

---

## Nano Banana Pro

- **Model ID**: `st-ai/nano-banana-pro` (text-to-image), `st-ai/nano-banana-pro-edit` (editing)
- **Task type**: t2i / i2i

Good for stylized and illustration outputs. Supports editing mode.

---

## Gemini 3 Pro Image

- **Model ID**: `st-ai/gemini-3-pro-image`
- **Task type**: t2i

Google's image generation model. Strong photorealism.

---

## Jimeng Series

- **Model IDs**: `st-ai/jimeng-4.5-pro`, `st-ai/jimeng-4.1`, `st-ai/jimeng-4.0`
- **Task type**: t2i

ByteDance's Jimeng models. Strong with Chinese text prompts. 4.5-pro is the most capable.

---

## Fetching Latest Model Docs

To get current parameters and pricing for any model:

```
GET https://api.xskill.ai/api/v3/models/<url-encoded-model-id>/llms.txt
```

Example: `https://api.xskill.ai/api/v3/models/fal-ai%2Fflux-2%2Fflash/llms.txt`

The full model list is at: `https://api.xskill.ai/api/v3/models`
