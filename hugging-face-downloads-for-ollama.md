# HuggingFace → Ollama: Manual Setup Guide

How to take any model from HuggingFace and run it locally with Ollama.

---

## Step 1 — Get a GGUF File

Ollama only understands GGUF format. You have two paths:

### A. Find a Pre-Converted GGUF (Recommended)

Search HuggingFace for `{model-name}-gguf` or `{model-name}-GGUF`. Common uploaders:

| Uploader | Notes |
|---|---|
| `bartowski` | Wide coverage, iMatrix quants |
| `mradermacher` | Static + iMatrix quants |
| `mmnga` | Japanese community, broad coverage |
| `TheBloke` | Legacy, but huge catalog |

**Quantization guide (pick based on your VRAM):**

| Quant | Quality | Size (16B model) | Best for |
|---|---|---|---|
| Q8_0 | Best | ~17 GB | 24 GB VRAM |
| Q6_K | Very good | ~14 GB | 16 GB VRAM |
| Q5_K_M | Good | ~12 GB | 16 GB VRAM |
| **Q4_K_M** | **Solid** | **~10 GB** | **12 GB VRAM** |
| Q4_K_S | Decent | ~10 GB | 12 GB VRAM (faster, slightly lower quality) |
| Q3_K_M | Acceptable | ~8 GB | 8 GB VRAM |

Download the `.gguf` file. For large files, use:

```bash
# Option 1: wget (works everywhere)
wget -O model.gguf "https://huggingface.co/USER/REPO/resolve/main/model-Q4_K_M.gguf"

# Option 2: huggingface-cli (if installed)
pip install huggingface-hub
huggingface-cli download USER/REPO model-Q4_K_M.gguf --local-dir .
```

### B. Convert Yourself (When No GGUF Exists)

```bash
# 1. Clone llama.cpp
git clone https://github.com/ggerganov/llama.cpp
pip install -r llama.cpp/requirements.txt

# 2. Download the model from HuggingFace
git clone https://huggingface.co/USER/MODEL-NAME ./model-dir
# OR: huggingface-cli download USER/MODEL-NAME --local-dir ./model-dir

# 3. Convert safetensors → GGUF
python llama.cpp/convert_hf_to_gguf.py ./model-dir --outtype q4_k_m --outfile model.gguf
```

---

## Step 2 — Create a Modelfile

A Modelfile is Ollama's blueprint for a model. Create a plain text file named `Modelfile`:

```
# Model info
FROM ./model.gguf

# Chat template — THIS IS THE CRITICAL PART
TEMPLATE """..."""

# Parameters
PARAMETER num_ctx 8192
PARAMETER stop "<|im_end|>"
```

### How to Find the Correct Template

The chat template lives in the model's `tokenizer_config.json` on HuggingFace. Go to:

```
https://huggingface.co/USER/MODEL-NAME/blob/main/tokenizer_config.json
```

Look for the `"chat_template"` field — it's a Jinja2 string. Translate it to Go template syntax:

| Jinja2 | Go Template (Ollama) |
|---|---|
| `messages` | `.Messages` |
| `message['role']` | `.Role` |
| `message['content']` | `.Content` |
| `add_generation_prompt` | Trailing assistant tokens before `{{ .Response }}` |
| `messages[0]['role'] != 'system'` | System prompt fallback logic |
| `{%- for message in messages -%}` | `{{- range .Messages }}` |
| `{%- if ... -%}` | `{{- if ... }}` |
| `{{ variable }}` | `{{ .Variable }}` |

The special tokens (`<|im_end|>`, `<|im_user|>`, etc.) are defined in the `added_tokens_decoder` and `additional_special_tokens` fields of the same file.

### Template Examples

**ChatML format (Qwen, many Chinese models):**
```
TEMPLATE """{{- range .Messages }}{{- if eq .Role "system" }}<|im_start|>system
{{ .Content }}<|im_end|>
{{- else if eq .Role "user" }}<|im_start|>user
{{ .Content }}<|im_end|>
{{- else if eq .Role "assistant" }}<|im_start|>assistant
{{ .Content }}<|im_end|>
{{- end }}{{- end }}{{- if .Response }}<|im_start|>assistant
{{ .Response }}<|im_end|>{{- end }}"""
```

**Llama 3 format:**
```
TEMPLATE """{{- if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>{{- end }}{{- range .Messages }}{{- if eq .Role "system" }}<|start_header_id|>system<|end_header_id|>

{{ .Content }}<|eot_id|>{{- else if eq .Role "user" }}<|start_header_id|>user<|end_header_id|>

{{ .Content }}<|eot_id|>{{- else if eq .Role "assistant" }}<|start_header_id|>assistant<|end_header_id|>

{{ .Content }}<|eot_id|>{{- end }}{{- end }}{{- if .Response }}<|start_header_id|>assistant<|end_header_id|>

{{ .Response }}<|eot_id|>{{- end }}"""
```

**Moonshot/Kimi format (Moonlight, Kimi):**
```
TEMPLATE """{{- if .System }}<|im_system|>system<|im_middle|>{{ .System }}<|im_end|>
{{- end }}
{{- range .Messages }}
{{- if eq .Role "system" }}<|im_system|>system<|im_middle|>{{ .Content }}<|im_end|>
{{- else if eq .Role "user" }}<|im_user|>user<|im_middle|>{{ .Content }}<|im_end|>
{{- else if eq .Role "assistant" }}<|im_assistant|>assistant<|im_middle|>{{ .Content }}<|im_end|>
{{- end }}
{{- end }}
<|im_assistant|>assistant<|im_middle|>{{ .Response }}"""
```

### Key Parameters

| Parameter | What it does | Recommended |
|---|---|---|
| `num_ctx` | Context window size in tokens | Match the model's native limit (check model card) |
| `num_predict` | Max tokens to generate | `-1` (unlimited) or set a cap |
| `temperature` | Creativity (0 = deterministic, 1 = creative) | `0.7` for chat, `0.2` for coding |
| `stop` | Stop sequences | The model's EOS tokens |
| `num_gpu` | GPU layers to use | Default (`-1` = auto) is usually fine |

---

## Step 3 — Register and Run

```bash
# Register the model in Ollama
ollama create my-model-name -f ./Modelfile

# Verify it worked
ollama list

# Test it
ollama run my-model-name "Hello, who are you?"

# Inspect what was registered
ollama show my-model-name --modelfile
ollama show my-model-name --parameters
```

---

## Common Pitfalls

| Problem | Likely Cause | Fix |
|---|---|---|
| Output is garbled / repetitive | Wrong TEMPLATE | Re-check `tokenizer_config.json`, translate Jinja2 correctly |
| Model won't load / "unsupported architecture" | Architecture not in llama.cpp | Check [llama.cpp supported models](https://github.com/ggerganov/llama.cpp#description). Some newer archs need latest Ollama. |
| Very slow generation | Model too big, spilling to RAM | Use a smaller quant (Q4_K_S instead of Q4_K_M) |
| Model runs forever | Missing or wrong `stop` tokens | Add `PARAMETER stop` for the model's EOS token |
| Truncated responses mid-sentence | Stop token triggered prematurely | Remove overly aggressive stop tokens |
| `ollama create` hangs on large GGUF | Normal — it's copying the blob to `~/.ollama/models/blobs/` | Be patient, especially with slow disks |

---

## Quick Reference: Moonlight-16B-A3B Example

| What | Value |
|---|---|
| HuggingFace | `moonshotai/Moonlight-16B-A3B-Instruct` |
| Architecture | DeepSeek-V3 (MoE, 16B total / 3B active) |
| Context | 8K tokens |
| Chat format | Moonshot / Kimi |
| GGUF source | `mmnga/Moonlight-16B-A3B-Instruct-gguf` |
| Recommended quant (12 GB) | Q4_K_M (~10 GB) |
| License | MIT |
