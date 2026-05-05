/**
 * Advisory commitlint config for AI commit conventions.
 * NOT wired to any pre-commit hook. Manual invocation only:
 *   npx --yes --package=@commitlint/cli commitlint --edit .git/COMMIT_EDITMSG
 * Prompt rules in opencode/AGENTS.md and opencode/COMMIT-CONVENTION.md are the authority.
 * This file is a structural sanity check — it cannot enforce mood, scope appropriateness,
 * or whether commit content matches the type. Self-contained: no `extends`, no
 * shareable config, no package.json. Only @commitlint/cli is fetched at runtime.
 */
/** @type {import('@commitlint/types').UserConfig} */
module.exports = {
  // Inline parser opts — mirrors @commitlint/parser-preset-conventionalcommits
  // grammar so we don't depend on @commitlint/config-conventional being fetched.
  parserPreset: {
    parserOpts: {
      headerPattern: /^(\w+)(?:\(([^)]+)\))?: (.+)$/,
      headerCorrespondence: ['type', 'scope', 'subject'],
      noteKeywords: ['BREAKING CHANGE'],
      revertPattern: /^revert:\s"?([\s\S]*?)"?\s*This reverts commit (\w*)\.?$/i,
      revertCorrespondence: ['header', 'hash'],
    },
  },
  plugins: [
    {
      rules: {
        'ai-attribution-forbidden': (parsed) => {
          const raw = parsed.raw || '';
          const patterns = [
            /Co-authored-by:\s*(Claude|GPT|Copilot|Gemini|Llama|ChatGPT|AI\b|Bot\b|Assistant\b)/i,
            /🤖/u,
            /\bGenerated with\b.*\b(Claude|GPT|Copilot|AI)\b/i,
            /\bPowered by AI\b/i,
            /noreply@anthropic\.com|copilot@github\.com|noreply@openai\.com/i,
          ];
          const hit = patterns.find((p) => p.test(raw));
          return [!hit, hit ? `AI-attribution forbidden (matched: ${hit})` : ''];
        },
        'subject-first-letter-lowercase': (parsed) => {
          const subject = parsed.subject || '';
          if (!subject) return [true]; // empty handled by 'subject-empty'
          const first = subject.charAt(0);
          // Reject if first char is an uppercase ASCII letter; allow non-letters,
          // digits, and any other Unicode (proper nouns/acronyms/filenames are still
          // allowed mid-subject — only the FIRST character is constrained).
          const ok = !(first >= 'A' && first <= 'Z');
          return [ok, ok ? '' : `subject must start with a lowercase letter (got "${first}"); proper nouns/acronyms/filenames are allowed mid-subject`];
        },
      },
    },
  ],
  rules: {
    'type-enum': [2,'always',['feat','fix','docs','style','refactor','perf','test','build','ci','chore','revert']],
    'type-case': [2,'always','lower-case'],
    'type-empty': [2,'never'],
    // 'subject-case' deliberately omitted — see custom rule 'subject-first-letter-lowercase' below.
    'subject-first-letter-lowercase': [2,'always'],
    'subject-empty': [2,'never'],
    'subject-full-stop': [2,'never','.'],
    'header-max-length': [2,'always',50],
    'body-max-line-length': [2,'always',72],
    'body-leading-blank': [2,'always','always'],
    'footer-leading-blank': [2,'always','always'],
    'scope-case': [2,'always','kebab-case'],
    'ai-attribution-forbidden': [2,'always'],
  },
};
