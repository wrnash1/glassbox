# Glassbox

**A real language model, running in your browser, with the lid off.**

Glassbox loads DistilGPT-2 entirely client-side (via [Transformers.js](https://github.com/huggingface/transformers.js)) and shows you, token by token, how a language model actually forms its predictions:

- **Token stream** — see your text the way the model sees it: chopped into subword tokens
- **Live prediction bars** — the model's top-10 guesses for the next token, with real probabilities
- **Step-through generation** — add the most likely token, sample randomly, or *click any candidate* to force it and watch the distribution re-form
- **Temperature slider** — drag it and watch the probability distribution flatten or sharpen in real time

**Privacy:** everything runs in your browser. Nothing you type is ever sent to a server. The only network traffic is the one-time model download (~45 MB) from the Hugging Face hub, which your browser then caches.

## Try it

Once GitHub Pages is enabled, the live demo is at:
`https://wrnash1.github.io/glassbox/`

Or run it locally — it's a single static file, so any web server works:

```bash
git clone https://github.com/wrnash1/glassbox.git
cd glassbox
python3 -m http.server 8080
# open http://localhost:8080
```

(You can't just double-click `index.html` — ES modules require it be served over http.)

## Enabling GitHub Pages

1. Repo **Settings → Pages**
2. Source: **Deploy from a branch**, branch `main`, folder `/ (root)`
3. Save — the site goes live at the URL above in a minute or two

## Why "Glassbox"?

Language models get called black boxes. The math inside them isn't magic — it's structure you can look at. Glassbox aims to make that structure visible to anyone with a browser: no Python environment, no GPU, no account.

## Roadmap

- **v0.2 — Attention visualization.** Render attention-head patterns as interactive arc diagrams. Requires ONNX model exports that include attention outputs (the standard Xenova exports emit logits only), so this involves a custom export step.
- **v0.3 — Layer-by-layer view.** Show how the prediction evolves through the network (logit lens).
- **v0.4 — Annotations.** Pull community neuron/head labels from the [Neuronpedia](https://www.neuronpedia.org/) API so the visuals come with meaning attached.
- **Bigger models** via WebGPU when available.

## Contributing

Issues and PRs welcome. The entire app is one dependency-free `index.html` on purpose — keep it that way as long as possible.

## License

[MIT](LICENSE)
