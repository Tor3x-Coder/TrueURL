# True URL

**Know before you tap.**

True URL is a Nigerian-first link and message checker. You paste a WhatsApp link or the whole broadcast, and it tells you whether it is a trap, **why** (in enough detail that FOMO does not win), and what the real official page is — or that no official version of this thing exists.

It is built for the group chat: fake JAMB portals, “Davido is gifting 20GB, click MTN / Glo / Airtel,” school-fees accounts, job-form fees, bank “verify now” pages, and every other forward that shows up at 1am.

> Status: planned. Hybrid checker (on-device first, optional live claim check). Flutter.

---

## The problem

People do not fall for scams because they are stupid. They fall because the message is designed to create **FOMO and panic**:

- Everyone in the group already tapped.
- It expires at midnight.
- Davido / MTN / JAMB / the school is involved.
- If you wait, you lose the data, the admission, the money.

A one-line “this looks suspicious” does not beat that. You need a verdict that takes the story apart.

---

## What True URL does

1. **Checks any kind of link**, not only exam boards. Telcos, banks, fintech, government, giveaways, jobs, “updates,” shorteners, the lot.
2. **Checks the whole message**, not just the URL. The bait is often in the words.
3. **Explains why**, in human sentences, aimed at the feeling the scam is using.
4. **Hands you the real official site** when the message is impersonating a real brand (MTN, JAMB, OPay, WAEC, …).
5. **Tells you when there is nothing to find.** There is no official “Davido 20GB wedding gift” page. Stop looking for the “real” link.
6. **Optionally asks the internet** whether the *story* is even happening (wedding, promo, “results are out”). That is a second step. It never replaces the link verdict.

What it will not do: call a random unknown site “safe,” run your banking, store OTPs, or let an AI override a fake domain.

---

## How it thinks (hybrid)

A paste is two different questions. True URL answers them separately.

| Layer | Question | Needs internet? | When |
|---|---|---|---|
| **1 — Inspector** | Is this link / script a trap? Who is it pretending to be? | No | Every check, instantly, on the phone |
| **2 — Claim check** | Is this event / promo even real? | Yes (search + model) | Only if you tap **Check if this is even happening** |

A wedding can be real **and** the 20GB link is still fake. The app is allowed to say both.

If Layer 2 is down (no data, no key, timeout), Layer 1 still stands. The live check is never on the critical path.

---

## Verdicts

We never stamp a stranger **SAFE**. That is how people get hurt.

| Stamp | Meaning |
|---|---|
| **OFFICIAL** | This *is* a known real brand domain (e.g. `jamb.gov.ng`, `mtn.ng`). |
| **UNKNOWN** | No trap signals, but we do not vouch for it. Look it up yourself. |
| **BE CAREFUL** | Shortener, `http`, odd TLD, messy URL. Not enough to scream fake. |
| **FAKE** | Impersonation, or a known bait script (free data, gift, “you have been selected,” pay-to-claim). |

---

## Reasons — detailed on purpose

Every **FAKE** / **BE CAREFUL** screen must do all of this. Not a bullet that says “suspicious domain.”

1. **Name the feeling.** “This is written to make you tap before you think. ‘Everyone is claiming 20GB’ is the hook.”
2. **Point at *this* link.** “The host is `mtn-data-gift.xyz`. MTN’s real site is `mtn.ng`. These are not close.”
3. **Point at *this* script.** “Celebrity name + free data + pick your network + short link is a WhatsApp template. It is recycled every time a rumour trends.”
4. **How the real brand actually behaves.** “MTN does not drop data gifts as anonymous group-chat links. Official promos live on mtn.ng and the MyMTN app.”
5. **The real door, or no door.** Big buttons for official MTN / Airtel / Glo — **or** “There is no official page for this gift. Don’t hunt for a cleaner link.”
6. **Cost of tapping vs waiting.** “If you tap: they can take a login, a number, or an OTP. If you wait 10 minutes: you lose nothing, because this gift is not real.”
7. **What to send back to the group.** One tap copies a verdict card so the next person does not have to wonder.

Layer 2, if used, is a **separate card**. It never rewrites the stamp. Example:

> Search: no official MTN, Airtel, Glo, or Davido channel is running a 20GB blast. Wedding rumours may exist. This link is still not how you get data.

---

## Who it is for

Students, parents, hostel group chats. First audience: people who live on WhatsApp and get blasted with “updates” and free-data forwards. Works as a 10-second check while someone holds their phone out.

---

## App flow

### First launch
1. Splash — wordmark + **Know before you tap.**
2. Welcome, 3 screens, skippable, once.
   - WhatsApp groups are a scam factory.
   - Paste a link or the whole message. We say why, and we give the real site or tell you there isn’t one.
   - We do not guess news. Brands we know. World events only if you ask us to look them up.
3. **Home. Not login.**

### Home (guest or signed in)
- Paste box. Toggle: **Link** / **Message**. Long paragraphs auto-flip to Message.
- Guest chip: `Checking as guest · Save history →`
- Last 3 checks as small stamps (if any).
- Tabs / drawer: Official book, Playbook, History, Profile.

### A check
1. Inspecting (~0.5s, real work, not a fake spinner).
2. Stamp + detailed reasons + official links or “no official version.”
3. If the text made a news/promo claim → button **Check if this is even happening.**
4. Actions: check another, share to WhatsApp, save (asks for account if guest), report.

### Auth (only when they need it)
From the guest chip, Save, or Profile.

- Google
- Email + password
- Stay guest

After login, return to wherever they were. History can sync. No phone OTP. No profile-completion wall. No “sign up to check.”

### Next launches
Straight to the paste box. No welcome.

### The 30-second demo
Open → paste the Davido 20GB message → **FAKE** → reasons that kill the FOMO → official MTN/Airtel/Glo → share to the group → optional live claim check as the encore.

---

## Features (v1)

- [x] Planned: on-device URL inspector (host, https, IP host, `@` phishing, punycode, shorteners, weird TLDs, lookalikes, brand-in-wrong-domain)
- [x] Planned: message inspector (free data, celebrity gift, scholarship/job fee, school fees + new account, OTP harvest, “you have been selected,” investment doubling)
- [x] Planned: official brand book (exams, government, banks, fintech, telcos) with “this brand will never…” lines
- [x] Planned: detailed anti-FOMO reason copy
- [x] Planned: “no official version of this exists”
- [x] Planned: WhatsApp-shareable verdict
- [x] Planned: welcome + guest-first auth (Firebase)
- [x] Planned: local history; cloud history after login
- [x] Planned: optional Layer 2 claim check (backend + search)
- [ ] Later: community “going around right now” feed
- [ ] Later: browser extension
- [ ] Later: phone-number / @handle official check

---

## Brand book (Layer 1)

Only domains we are sure about get **OFFICIAL**. If we are not sure, it is not in the book.

Starter set:

- **Exams:** jamb.gov.ng, waecdirect.org, waecnigeria.org, neco.gov.ng, nabteb.gov.ng
- **Gov:** nysc.gov.ng, nimc.gov.ng, inec.gov.ng, firs.gov.ng, cbn.gov.ng, immigration.gov.ng, education.gov.ng
- **Telcos:** mtn.ng, mtnonline.com, airtel.com.ng, gloworld.com, 9mobile.com.ng
- **Banks / fintech:** firstbanknigeria.com, gtbank.com, accessbankplc.com, zenithbank.com, kuda.com, opayweb.com, palmpay.com, moniepoint.com, paystack.com, flutterwave.com

Subdomains of a book domain (e.g. `efacility.jamb.gov.ng`) count as official.  
`jamb.gov.ng.evil.com` does **not** — that is a classic fake.

We do **not** list random “JAMB WhatsApp numbers.” If someone texts you a JAMB or MTN support number, that is the scam.

---

## Tech stack

| Piece | Choice | Why |
|---|---|---|
| App | **Flutter** (iOS, Android, later web) | One codebase, ships on the phones classmates actually use |
| Layer 1 | Pure Dart, on device | Instant, works on dead data, cannot hallucinate |
| Layer 2 | Small backend (Cloud Function or tiny server) + search/LLM | Only for “is this happening?” |
| Auth | Firebase Auth (Google + email) | Real accounts, free tier, guest stays guest |
| History | Local first (Hive / shared_prefs). Firestore after login | Guest still has last checks on that phone |
| State | Decide at first code (Provider or Riverpod) | Keep it boring |

No VirusTotal dependency for v1. No SMS OTP.

---

## Repo layout (after `flutter create trueurl`)

```
trueurl/
  README.md                 ← this file
  pubspec.yaml
  lib/
    main.dart
    app.dart
    theme/
    features/
      welcome/
      auth/
      check/                ← paste box, inspecting, verdict
      book/                 ← official directory
      playbook/
      history/
      profile/
    inspector/              ← Layer 1, no Flutter widgets
      url_inspector.dart
      message_inspector.dart
      lookalike.dart
      reasons.dart          ← anti-FOMO copy
      brands.dart
    claim/                  ← Layer 2 client (optional call)
    data/
    widgets/
  functions/                ← Layer 2 backend (later)
  test/
    inspector_test.dart     ← these tests matter more than widget tests
```

Layer 1 lives in `lib/inspector/` with **zero** Flutter imports so we can unit-test every scam example without a device.

---

## Getting started

You need: Flutter SDK, a GitHub account, later a free Firebase project.

```bash
flutter create trueurl
cd trueurl
```

Replace the generated `README.md` with this file.

```bash
flutter pub get
flutter run
```

Firebase and the Layer 2 function are added when we start those features. Until then the checker is fully local.

### Environment (later)

```
# .env  (never commit)
FIREBASE_...
CLAIM_CHECK_URL=
CLAIM_CHECK_KEY=
```

---

## Privacy

- Guest checks stay on the device.
- Signed-in history is tied to that account so they can see past verdicts.
- We do not need contacts, SMS, or location.
- Layer 2 only sends the claim text / URL they already pasted, when they tap the extra button.
- We are not a bank and not the police. We do not collect OTPs, BVN, NIN, or passwords. If a screen ever asked for those, it would not be us.

---

## Disclaimer

True URL is a first-pass inspector, not a guarantee. New scam sites appear every day. **OFFICIAL** means “this domain is in our book,” not “nothing bad can happen there.” **UNKNOWN** means “we do not know,” not “safe.” When in doubt, type the real site yourself. Never send an OTP to a chat.

---

## Roadmap

**Weekend v1** — welcome, guest-first auth shell, Layer 1 inspector, detailed reasons, official book, share card, local history.

**Right after** — Firebase wired for real Google/email, history sync, Layer 2 claim-check button.

**Later** — web build, “going around” reports, more brands, lookalike screenshots.

---

## Contributing

This is a product, not a dumping ground. New brand domains only if you can prove they are official. New scam scripts only with a real example message. Layer 1 tests must pass before Layer 2 gets any smarter.

---

## License

Personal / student project for now. All rights reserved unless a license file is added.

---

## Credits

Built for the group chat. First audience: students who are tired of watching people tap.

**True URL** — Know before you tap.