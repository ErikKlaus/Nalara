# 📊 Business Requirements Document (BRD)
## Nalara — Decision Intelligence Platform
**Versi:** 1.0.0-MVP | **Tanggal:** 6 Mei 2026 | **Status:** Draft

---

## 1. Business Context

### 1.1 Latar Belakang

Indonesia memiliki **229 juta pengguna internet** (penetrasi 80.5%) dan **86% smartphone penetration** di 2025. Adopsi AI di kalangan knowledge worker Indonesia tercatat **92%**, namun daily usage baru **16%**. Ini menunjukkan gap besar antara awareness dan habit — peluang bagi produk AI yang memberikan **value nyata dan berulang**.

Sementara itu, pasar decision intelligence global didominasi enterprise tools (IBM watsonx, Palantir, SAS Viya) yang tidak accessible bagi individu. **Tidak ada produk lokal Indonesia yang fokus pada personal decision support berbasis AI.**

### 1.2 Problem Statement

> Knowledge worker Indonesia usia 20–40 tahun tidak memiliki tool terstruktur untuk mengevaluasi risiko keputusan penting secara rasional, menyebabkan overthinking, decision paralysis, dan fear of regret.

### 1.3 Proposed Solution

Nalara menghadirkan **pre-mortem analysis yang ditenagai AI** — teknik yang biasa digunakan di perusahaan besar — dalam format yang ringan, personal, dan mobile-first untuk pasar Indonesia.

---

## 2. Market Analysis

### 2.1 Market Size (Indonesia)

| Segment | Size | Source |
|---------|------|--------|
| Total Internet Users | ~229 juta | DataReportal 2025 |
| Knowledge Workers (20-40 tahun) | ~35 juta | BPS + estimasi |
| Sudah pakai AI tools | ~32 juta (92%) | PwC 2026 |
| Daily AI users | ~5.6 juta (16%) | PwC 2026 |
| **Serviceable Addressable Market** | ~5-10 juta | Knowledge workers yang rutin ambil keputusan besar |
| **Serviceable Obtainable Market (Y1)** | ~10K-50K | Realistic MVP target |

### 2.2 Market Trends

| Trend | Relevansi untuk Nalara |
|-------|----------------------|
| **Agentic AI rise** | Nalara sebagai "personal decision agent" |
| **AI governance focus** | Nalara transparan: confidence level + reasoning |
| **Mobile-first Indonesia** | Flutter web + mobile, responsive design |
| **Local language AI** | Gemini output dalam Bahasa Indonesia |
| **National AI Roadmap 2025-2030** | Sejalan dengan visi pemerintah untuk AI adoption |

### 2.3 Competitive Landscape

| Competitor | Type | Weakness vs Nalara |
|-----------|------|-------------------|
| ChatGPT / Gemini (general) | General AI chatbot | Tidak terstruktur, tidak ada follow-up |
| Notion AI | Productivity tool | Bukan decision-specific, tidak ada pre-mortem |
| Decision Matrix tools | Spreadsheet-based | Manual, tidak ada AI, tidak mobile |
| Enterprise DI (Palantir, IBM) | Enterprise platform | Mahal, kompleks, bukan untuk individu |
| **Nalara** | **Personal DI** | **Structured, AI-powered, Indonesia-focused, follow-up system** |

### 2.4 Unique Value Proposition

```
Nalara = Pre-mortem AI + Bahasa Indonesia + Personal Context + Follow-up System
```

| Differentiator | Detail |
|---------------|--------|
| **Pre-mortem structured output** | Bukan chat open-ended, tapi 3 skenario + causes + indicators + actions |
| **Indonesia-first** | UI dan AI output native Bahasa Indonesia |
| **Actionable timing** | Setiap action punya timing: hari ini, besok, minggu ini, bulan ini |
| **Decision follow-up** | Reminder D+7/D+30 untuk evaluasi — tidak ada competitor yang punya ini |
| **Confidence transparency** | User tahu seberapa reliable analisis AI |

---

## 3. Stakeholder Analysis

| Stakeholder | Role | Interest | Influence |
|------------|------|----------|-----------|
| End Users (Knowledge Workers) | Primary user | Tool pengambilan keputusan yang cepat & terstruktur | High |
| Founder / Product Owner | Visionary & decision maker | Product-market fit, growth | Very High |
| Development Team | Builder | Maintainable code, clear specs | High |
| Investors (Future) | Funder | Market traction, revenue potential | Medium |
| Google/Firebase | Platform provider | Usage & adoption metrics | Low |

---

## 4. Business Requirements

### 4.1 Requirement Mapping

| BR ID | Business Requirement | Product Feature | Priority |
|-------|---------------------|----------------|----------|
| BR-001 | User dapat mendaftar dan login dengan mudah | Google Sign-In (account picker) | P0 |
| BR-002 | User dapat menginput keputusan dalam bahasa mereka | Multi-language input + AI output (ID/EN) | P0 |
| BR-003 | User mendapat analisis risiko terstruktur | 3 failure scenarios + causes + indicators + actions | P0 |
| BR-004 | User tahu seberapa reliable analisis | Confidence level + reason | P0 |
| BR-005 | User dapat menyimpan dan mengakses histori | Firestore persistence + history screen | P0 |
| BR-006 | User diingatkan untuk review keputusan | In-app reminder D+7, D+30 | P1 |
| BR-007 | User termotivasi untuk menggunakan rutin | Usage streak di dashboard | P2 |
| BR-008 | Biaya operasional terkontrol | AI usage limit (3/hari) + system hard cap (1.400/hari) | P0 |
| BR-009 | Data user aman dan terisolasi | Firebase Security Rules + encryption | P0 |
| BR-010 | App berfungsi meski koneksi tidak stabil | Offline draft + auto-sync | P1 |
| BR-011 | User mendapat klarifikasi jika input kurang | Clarification flow (AI-driven) | P0 |
| BR-012 | Operasional dapat dimonitor | Usage logs + system config + monitoring | P0 |

### 4.2 Business Rules

| Rule ID | Rule | Enforcement |
|---------|------|-------------|
| BRU-001 | Maksimal 3 analisis per user per hari (free) | Cloud Functions + Firestore |
| BRU-002 | Reset limit pukul 00:00 WIB | Scheduled Cloud Function |
| BRU-003 | Re-generate dihitung sebagai analisis baru | Cloud Functions counter |
| BRU-004 | System hard cap 1.400 req/hari | Cloud Functions + system_config |
| BRU-005 | Draft auto-delete setelah 24 jam | App launch cleanup |
| BRU-006 | Firestore = single source of truth | Sync strategy |
| BRU-007 | AI tidak boleh beri saran medis/hukum/investasi | Prompt guardrails |
| BRU-008 | API key Gemini tidak boleh di client | Cloud Functions only |
| BRU-009 | Rate limit 10 req/menit per UID | Cloud Functions |
| BRU-010 | Setiap transisi status hanya bergerak maju | State machine enforcement |

---

## 5. Revenue Model

### 5.1 MVP (Current) — Free Tier Only

| Aspect | Detail |
|--------|--------|
| Model | 100% free, no monetization |
| Purpose | Validate product-market fit |
| Target | 1.000-5.000 registered users in 3 months |
| Cost managed by | Usage limits + hard cap |

### 5.2 Post-MVP Revenue Projections (Roadmap)

| Model | Description | Est. Revenue/User/Month |
|-------|------------|------------------------|
| **Freemium** | Free: 3/hari → Premium: unlimited | IDR 49.000-99.000 |
| **Token-based** | Buy analysis packs (10, 25, 50) | IDR 25.000-100.000 per pack |
| **B2B/Enterprise** | Team decision workspace | IDR 500.000-2.000.000/team/month |
| **Data Insights** | Anonymized decision trend reports | Partnership model |

### 5.3 Unit Economics Projection

| Metric | Value | Assumption |
|--------|-------|------------|
| Gemini 1.5 Flash cost per request | ~$0.0005 | ~800 tokens output |
| Firebase Firestore cost (per 100K reads) | ~$0.06 | Standard pricing |
| Cloud Functions (per 1M invocations) | ~$0.40 | 256MB, <15s |
| **Cost per user per day** | ~$0.002 | 3 analyses/day |
| **Cost per user per month** | ~$0.06 | Average 2 analyses/day |
| **Monthly cost at 5.000 MAU** | ~$300 | Within bootstrap budget |
| **Monthly cost at 50.000 MAU** | ~$3.000 | Requires revenue |
| **Break-even** (Freemium @ 5% conversion) | ~10.000 MAU | At IDR 49.000/month premium |

---

## 6. Cost Analysis (MVP Phase)

### 6.1 Infrastructure Costs

| Service | Free Tier | Estimated Usage (MVP) | Est. Monthly Cost |
|---------|-----------|----------------------|-------------------|
| Firebase Auth | 10K/month | <5K | $0 |
| Firestore | 50K reads/day, 20K writes/day | ~5K reads, ~1K writes/day | $0 (within free tier) |
| Cloud Functions | 2M/month | ~40K/month | $0 (within free tier) |
| Gemini API | Generous free tier | ~1.400/day max | $0-$21/month |
| Firebase Hosting | 10GB/month | <1GB | $0 |
| **Total MVP** | — | — | **$0-$25/month** |

### 6.2 Development Costs

| Resource | Duration | Notes |
|----------|----------|-------|
| 1 Full-stack Developer | 8-10 weeks | Flutter + Firebase + Cloud Functions |
| UI/UX Design | 2 weeks | Can overlap with development |
| QA Testing | 1-2 weeks | Manual + automated |

---

## 7. Key Performance Indicators (KPIs)

### 7.1 Product KPIs

| KPI | Target (Month 1) | Target (Month 3) | Measurement |
|-----|------------------|-------------------|-------------|
| Registered Users | 500 | 3.000 | Firebase Auth |
| Monthly Active Users (MAU) | 200 | 1.500 | Firebase Analytics |
| Daily Active Users (DAU) | 50 | 400 | Firebase Analytics |
| Analyses Completed/Day | 100 | 800 | Firestore logs |
| Avg Analyses/User/Day | 1.5 | 2.0 | Calculation |
| Save Rate (Analyzed → Saved) | >40% | >55% | Firestore |
| Onboarding Completion | >75% | >85% | Firebase Analytics |

### 7.2 Engagement KPIs

| KPI | Target | Measurement |
|-----|--------|-------------|
| D1 Retention | >40% | Firebase Analytics |
| D7 Retention | >20% | Firebase Analytics |
| D30 Retention | >10% | Firebase Analytics |
| Reminder Tap Rate | >15% | Firestore |
| Avg Session Duration | >3 min | Firebase Analytics |
| Avg Streak Length | >2 days | Firestore |

### 7.3 Technical KPIs

| KPI | Target | Measurement |
|-----|--------|-------------|
| AI Success Rate | >95% | Cloud Functions logs |
| AI Avg Latency | <6s | Cloud Functions logs |
| App Crash Rate | <1% | Crashlytics |
| Uptime | >99.5% | Cloud Monitoring |

---

## 8. Risk Assessment

### 8.1 Business Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Low product-market fit | Medium | Critical | Validate with 100 users before full launch |
| Users treat it as novelty (1-time use) | High | High | Reminder system, streak, decision journal |
| AI output feels generic | Medium | High | Strict prompt engineering, quality validation |
| Competitor launches similar product | Low | Medium | First-mover advantage in Indonesia market |
| Gemini pricing increase | Low | High | Abstracted AI layer, can switch models |
| Regulatory concern (AI advice) | Low | Medium | Disclaimers, no medical/legal/financial advice |

### 8.2 Operational Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Hard cap reached (1.400/day) | Low (MVP) | Medium | Monitor, ready to increase |
| Firebase cost spike | Low | Medium | Budget alerts, usage monitoring |
| Gemini API instability | Medium | High | Retry logic, error handling, cache |
| Data breach | Very Low | Critical | Security rules, encryption, audit |

---

## 9. Go-to-Market Strategy (MVP)

### 9.1 Launch Phases

| Phase | Timeline | Activities |
|-------|----------|-----------|
| **Alpha** | Week 1-2 | Internal testing, 10-20 testers |
| **Closed Beta** | Week 3-4 | 100 invited users, feedback collection |
| **Open Beta** | Week 5-8 | Public launch, organic growth |
| **GA** | Week 9+ | Full launch with marketing |

### 9.2 Distribution Channels

| Channel | Strategy | Est. Reach |
|---------|----------|------------|
| Twitter/X Indonesia | Tech community, career advice threads | Medium |
| LinkedIn Indonesia | Professional decision-making content | High |
| Instagram | Visual content: "Before Nalara vs After Nalara" | Medium |
| TikTok | Short demo videos, decision-making tips | High |
| Tech communities | Telegram groups, Discord servers | Medium |
| University partnerships | Career center collaborations | Medium |
| Product Hunt | International exposure | Low-Medium |

### 9.3 Content Strategy

| Content Type | Frequency | Platform |
|-------------|-----------|----------|
| Decision tips & frameworks | 3x/week | All social |
| User stories (anonymized) | 1x/week | Blog + social |
| Product updates | Bi-weekly | All channels |
| "Decision of the Week" | 1x/week | Twitter + LinkedIn |

---

## 10. Compliance & Legal

| Aspect | Requirement | Status |
|--------|------------|--------|
| **Privacy Policy** | Required — data collection disclosure | To be created |
| **Terms of Service** | Required — usage terms, disclaimers | To be created |
| **AI Disclaimer** | "Nalara bukan pengganti saran profesional" | In-app |
| **Data Protection** | UU PDP (Indonesia Personal Data Protection) | Compliant by design |
| **Google OAuth** | Comply with Google API Services User Data Policy | Required |
| **Content Moderation** | AI output guardrails (no medical/legal/investment) | Implemented in prompts |

---

## 11. Success Criteria (MVP)

### 11.1 Go/No-Go Criteria for Full Launch

| Criteria | Threshold | Measurement |
|----------|-----------|-------------|
| ✅ Onboarding < 60 seconds | >80% users | Analytics |
| ✅ AI response < 10 seconds | >90% requests | Logs |
| ✅ User rates output as "useful" | >60% | In-app survey |
| ✅ D7 retention | >15% | Analytics |
| ✅ Save rate | >40% | Firestore |
| ✅ Crash rate | <1% | Crashlytics |
| ✅ No critical security issues | 0 | Security audit |

### 11.2 Kill Criteria

| Criteria | Threshold | Action |
|----------|-----------|--------|
| D7 retention < 5% after 1 month | Pivot product | Reassess value prop |
| Save rate < 15% | Major UX revision | Users don't find results valuable |
| AI error rate > 20% | Technical fix | Prompt/model issues |
| Cost per user > $0.50/month at scale | Revenue model needed | Accelerate monetization |

---

## 12. Gap Analysis & Innovation Opportunities

### 12.1 Gaps Identified in Current Market

| Gap | Current State | Nalara's Approach |
|-----|--------------|-------------------|
| **No personal DI tool** | Enterprise-only or general chatbots | Structured, personal, AI-powered |
| **No follow-up mechanism** | AI gives advice, no accountability | D+7/D+30 reminder + notes |
| **No local language DI** | English-dominant tools | Native Indonesian AI output |
| **No decision history** | Chat history ≠ decision tracking | Persistent, searchable history |
| **No confidence transparency** | AI always sounds confident | Explicit confidence level + reasoning |

### 12.2 Innovation Opportunities (Post-MVP)

| Innovation | Description | Business Value |
|-----------|-------------|---------------|
| **Decision Journal** | AI-assisted post-decision reflection | ↑ Retention, ↑ engagement |
| **Success Scenarios** | Balance pre-mortem with positive scenarios | ↑ User satisfaction |
| **Emotional Intelligence** | Tag emotions during input for bias awareness | ↑ Differentiation |
| **Community Insights** | Anonymous benchmarks: "78% users with similar decisions..." | ↑ Trust, ↑ virality |
| **Decision Templates** | Pre-filled templates for common decisions | ↓ Friction, ↑ conversion |
| **Voice Input** | Speech-to-text for mobile convenience | ↑ Mobile engagement |
| **Contextual Data** | Integrate Indonesia economic data for financial decisions | ↑ Output quality |
| **B2B Expansion** | Team workspace for organizational decisions | ↑ Revenue potential |

---

## 13. Appendix

### A. Glossary

| Term | Definition |
|------|-----------|
| **Pre-mortem** | Teknik analisis yang mengasumsikan proyek/keputusan telah gagal dan menelusuri mundur penyebabnya |
| **Decision Intelligence** | Disiplin yang menggabungkan AI, data science, dan social science untuk meningkatkan kualitas keputusan |
| **Confidence Level** | Tingkat keyakinan AI terhadap kualitas analisis yang diberikan |
| **Hard Cap** | Batas maksimal request AI system-wide per hari |
| **Outbox Queue** | Antrian data lokal yang belum disinkronkan ke server |
| **Cursor-based Pagination** | Teknik pagination yang menggunakan pointer (cursor) alih-alih offset |

### B. References

1. DataReportal — Digital 2025 Indonesia
2. PwC — AI Jobs Barometer 2026
3. Gartner — Decision Intelligence Market Guide 2025
4. Indonesia National AI Roadmap 2025-2030
5. Gary Klein — "Performing a Project Premortem" (HBR)

---

*Dokumen ini adalah living document dan akan diperbarui seiring perkembangan bisnis.*
