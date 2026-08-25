# TikTok TechJam 2026 (Early Bird Access) — Tracks & Problem Statements

> Transcribed from two full-page screenshots of the Lark wiki page
> (bytedance.larkoffice.com/wiki/DNtSwxgeciCS2nkiUefc5qqtnkf).
> The screenshots were heavily downscaled; sections marked *[illegible]* need a
> higher-resolution re-capture. Track 2 below is largely complete; Track 1 is
> only partially readable.

## Page structure (from sidebar / layout)

- Webinar Schedule (28 Aug) — technical workshop webinars per track
- **Track 1: Agent Lark Use → Design and Build Lightweight Agent Middleware** *(title partially legible)*
- **Track 2: Autonomous Machine Learning Research Agent for Recommender Systems**
- Appendices, Judging Criteria, FAQ sections

---

## Track 1 — Agent + Lark: Design and Build Lightweight Agent Middleware *(partial)*

*Screenshot too downscaled to transcribe faithfully. Visible structure:*

- 1.1 Challenge Overview — table of goals/requirements (project scope, tech stack, differences)
- 1.2 Demo UI — screenshots of a Lark-style chat UI with a form/dialog; a Lark
  middleware architecture diagram; tables of components and constraints
- 1.3 For the hackiest part — Requirements / "Then we did" code snippets,
  environment variables / installation steps
- 1.4 Prelim- and Middleware Design Requirements
- 1.5 Agent Lifecycle / Rich Content Experience
- 1.6 Plug-in / New Up Implementation Plan (numbered table)
- 1.7 Recommended Middleware Directions and Examples — several example
  middleware concepts, each with description tables (e.g. context/memory,
  form/approval flows, rate limiting / safety, app coordination)
- 1.8 Respond-to-Docs
- 1.9 Deliverables
- 1.10 Live Sessions / Deadlines / Judging, Execution FAQs

**FAQ fragments legible at top of image 1 (belongs to Track 1):**
- Do we need BytePlus ECS? No. Local Docker, Colima, or Podman is the default judging path. Cloud deployment is optional.
- Do we have to select one recommended example? No. The examples are starting points. Teams may adapt, combine, simplify, replace, or invent capabilities that fit their platform.
- Can we use mock users or resources? Yes. Controlled fixtures are encouraged when they make middleware behavior reproducible.
- Does a polished UI count as middleware? No. The UI may explain and visualize a capability, but the behavior must execute in a trusted backend: Runtime, data, or infrastructure path.
- Why does Ark return 401 Unauthorized? The most common cause is using a BytePlus account AK/SK instead of an Ark model API key, or using the wrong endpoint ID.
- Where should we start reading the code? Begin with `apps/server/src/typos.ts`, `apps/server/src/app.ts`, `apps/server/src/agent-service.ts`, and the two Agent/Runner implementations. Then inspect `apps/web/src/App.tsx` for the smallest UI integration point.
- How to access the Starter Kit? (GitHub link — illegible)

---

## Track 2 — Autonomous Machine Learning Research Agent for Recommender Systems

> Problem Statement last updated: **25 August 2026, 9:10 PM**.
> Technical Workshop Webinar with Q&A: **28 Aug, 2:00–2:45 pm** (registration link on page).

### 2.1 Background

**Motivation.** ML engineers (MLEs) spend much of their time on a single activity: taking a dataset and a set of metrics, then iterating on a model again and again to push the score higher. The work is inherently cyclic — every round repeats the same loop (Figure 1):

1. **Read the problem** — understand the given dataset and the target metrics.
2. **Inspect data** — study data distribution through exploratory data analysis (EDA).
3. **Engineer features** — build and select input features (see Appendix 4.3).
4. **Train + tune** — choose a model, set the loss function, and tune hyperparameters.
5. **Evaluate** — read the metrics, check for overfitting, and consult the leaderboard.

The result of the evaluate stage drives a **reflect + revise** step, which decides what to change and loops back into the next iteration — re-inspecting the data and adjusting the features. The cycle repeats until the score plateaus.

Two of those stages — engineer features and train + tune — are carried out almost entirely in code: the engineer writes scripts to transform the data, define the model, and run training. In other words, each turn of the loop produces and modifies code. This is what makes the loop a natural target for automation: it is structured and repeatable, yet writing and revising that code is exactly the kind of task a code-generating LLM can take on.

The loop is also repetitive and mechanical; it draws heavily on "engineering intuition," but many individual steps are well structured and repeatedly exercised in practice — which is precisely why automating the whole cycle has become an active research direction.

**Prior work.** Over the past two years, a new line of work automates this loop: the **Autonomous ML Research Agent**, an LLM-driven agent that runs the cycle in Figure 1 on its own. It reads the problem, **writes the code** for each stage, trains and evaluates the model, reflects on the results, revises its approach, and finally produces a submission. Representative systems:

- **MLE-Bench [1]** (OpenAI) — a benchmark of 75 Kaggle competitions, now a standard evaluation suite for such agents.
- **AIDE [2]** (Weco AI) — a state-of-the-art agent that frames ML engineering as code optimization and explores the space of solutions via tree search.
- **AI-Scientist-v2 [3]** (Sakana AI) — an end-to-end agent for autonomous scientific and ML research, using agentic tree search to form hypotheses, run experiments, and write up results.

**This challenge.** Design an **autonomous ML research agent**: given a public ML dataset and a set of metrics, the agent must **autonomously** run the full loop of Figure 1 — read the problem, engineer features, train and tune the model, evaluate, then reflect and iterate — to reach the highest possible score across the test sets. Writing the code for each stage is part of the agent's job, not something provided in advance.

*New to recommender systems?* The benchmarks in this challenge come from the recommendation domain (the KuaiRand family). If terms such as CTR, multi-task learning, NDCG, or Recall@K are unfamiliar, start with the **Appendix: A Primer on Recommender Systems** — a one-topic read designed to get you oriented in 1–2 hours.

### 2.2 Problem Statement

**The Task.** Design and implement an Autonomous ML Research Agent. For each benchmark, the agent must autonomously:

1. **Reproduce the official baseline.** Stand up a working end-to-end pipeline and confirm it reaches the official baseline's reported validation score. (The official baseline is a fixed, organizer-provided reference — see Benchmarks. Any starter pipeline the agent builds for itself is an internal step, not the reference; it is a scored agent.)
2. **Iterate on the pipeline.** Autonomously draw on established methods from both industry and academia to improve each stage of the pipeline (see Figure 1), and apply those improvements in code. The agent develops using **only the training split and the public validation feedback** — it never has access to the hidden test set.
3. **Improve over the baseline.** Through repeated iterations, drive the **validation** score above the official baseline. Improvement need not be strictly monotonic — as with real-world data, the trajectory may fluctuate — but the agent should show a clear, sustained ability to keep improving, relative to the baseline. Final ranking is computed once, on the **hidden test set**, using the submission the agent designates as final.

**Task Requirements.**

1. **Runs end-to-end and aims to beat the baseline.** The agent must run the full pipeline on the required benchmark (KuaiRand-Pure) and reach a converged result; attempting the bonus benchmarks (KuaiRand-1k & KuaiRand-27k) is optional. The target is a hidden-test score that exceeds the official baseline; the actual delta achieved — positive or negative — is what feeds into the Primary metric scoring (see Judging Criteria), so falling short of the baseline is scored continuously rather than treated as a disqualifying failure.
2. **Iterates autonomously across the full stack.** The agent should improve the solution on its own, driven by its own evaluation of results. Improvements may target any part of the algorithmic stack — not just the model architecture, but every upstream and downstream module in the pipeline. The goal is to **minimize human intervention** — a fully autonomous run is the ideal, but a well-instrumented **semi-automated** pipeline that requires only a handful of interventions is an acceptable and realistic outcome; in practice, we measure how little human intervention a run requires (e.g. the number of manual interventions).
3. **Robust operation.** The pipeline should run reliably with **minimal human intervention**. Robustness here is about how the agent handles difficulty, not how often it succeeds — we do not score it by failure count, since a capable agent may fail only on genuinely hard problems. What matters is that when a step fails (a code error, a timeout, an unexpected input), the agent can recover, retry, or route around it, and that long iterative runs neither crash, stall, nor diverge.

### 2.3 Constraints & Scope

| Category | Constraints & Scope Details |
|---|---|
| In scope | Any open-source library or framework (PyTorch, RecBole, TorchRec, LightGBM, …); any papers, public solutions, or pre-trained weights; changes to any pipeline stage — not just the model |
| Out of scope | No external training data or pretrained weights trained on these benchmarks' test labels; no hidden-test access during development (train + validation only) |
| Limits | KuaiRand-Pure: NDCG@10 / Recall@10; core + positive (fixed) (required); KuaiRand-1k & KuaiRand-27k: same task and metrics (bonus); hidden test scored once, on the final submission; compute budget: *[illegible]* |
| Allowed assumptions | Fixed train / validation / hidden-test split per dataset; official baseline, scores & evaluation script (incl. convergence rule); example submission + actual schema |

### 2.4 Available Resources & Data

**Starter Kit** — to lower the barrier to entry, especially for participants new to recommender systems, the challenge provides a standard starting point:

1. **Fixed data splits:** KuaiRand itself provides data splits according to dates (`log_standard_x_08_to_4_21_*.csv` & `log_standard_4_22_to_5_08_*.csv`); you can use 4/08–4/21 standard + train, 4/22–5/08 standard first 50% + validation, 4/22–5/08 standard last 50% + test. Teams develop on train + validation only, and evaluate the performance on test set.
2. **Official baseline:** a fixed, organizer-provided reference pipeline per dataset (refer to CWM for KuaiRand), with its baseline scores published. Beating the baseline is what counts — not a baseline the team builds itself.
3. **Evaluation script:** the exact scoring code (NDCG@K / Recall@K for KuaiRand), plus the convergence rule (± and M) and the absolute-delta aggregation. Refer to CWM for KuaiRand.
4. **Submission format:** a minimal, runnable example submission and the required output schema.
5. **Run-log requirements:** each iteration should record its **hypothesis**, the **code diff**, the resulting **metrics**, and any **error / recovery events**. These logs are how judges assess **Autonomy** (scored under Impact & Relevance) and **Robustness** (scored under Technical Execution) — see Judging Criteria.
6. **LLM coding agent:** you can use whatever you like, or use Trae from ByteDance, which provides "Limited offer: new user 7-day free trial".

**Benchmarks.** **KuaiRand-Pure is required** and determines 100% of the primary score. **KuaiRand-1k and KuaiRand-27k are bonus datasets** — attempting them is optional and earns extra credit, but neither is required to complete the primary score.

**Resource policy.** This is a hackathon, so external resources are open by default: use any open-source library (PyTorch, RecBole, TorchRec, LightGBM, …), read any papers, docs, or public solutions, and use pretrained model weights freely. The agent is expected to draw on whatever published methods it can find — that is what makes it a research agent.

**One hard rule: no external training data.** Training must rely only on the KuaiRand datasets listed below — no augmenting, joining, or pre-training on any other dataset, and no pretrained model whose weights were trained on these benchmarks' test labels. This single rule is what keeps the hidden-test ranking fair; everything else is unrestricted.

| Dataset | Domain & Description | Metrics | Scale |
|---|---|---|---|
| KuaiRand (Kuaishou). Three released variants: **KuaiRand-Pure** is required, while **KuaiRand-1k** and **KuaiRand-27k** are bonus. | Short-video feed. 12 feedback signals (click / like / follow / comment / forward / long_view / play_time …) plus a randomized-exposure intervention that supports counterfactual evaluation. **Relevance label and K are fixed by the organizers** (see Starter Kit / TBB): the default task treats `click` as the positive relevance label and reports NDCG@10 / Recall@10. The exact label definition and K values are pinned in the Starter Kit so every team scores the same task. | NDCG@10 / Recall@10 | Pure: 1.4M interactions (27k users × 7.6k items); 1k: 11.7M; 27k: 322M. |

Links: KuaiRand — https://kuairand.com. KuaiRand's randomized-exposure data also enables off-policy / counterfactual evaluation (OPE).

### 2.5 Expected Deliverables

1. **Written Project Description (via Devpost)** — a clear written description of your project that includes:
   - How your solution addresses the problem statement
   - Development tools used (e.g. VSCode, Colab, Jupyter)
   - APIs used (e.g. OpenAI GPT-4o, Google Maps API)
   - Libraries and frameworks used (e.g. Hugging Face Transformers, PyTorch, scikit-learn, pandas)
   - Datasets and assets used (e.g. Google Local Reviews dataset, manually labelled data)
2. **Public Code/GitHub Repository** — submit a link to a public repository containing:
   - Well-structured, commented code covering all components of your solution
   - A README file that includes: project overview, setup and installation instructions, steps to reproduce your results
   - *(remainder cut off in screenshot)*

---

*[Sections beyond 2.5, the appendices, judging criteria details, and most of Track 1 were not legible in the provided screenshots.]*
