# skills

Personal [agent skills](https://skills.sh) repo, installable with the `skills` CLI:

```bash
npx skills add brandonnoad/skills           # browse + pick
npx skills add brandonnoad/skills --list    # list without installing
```

## Layout

```
skills/
  mattpocock/   # forked from mattpocock/skills, customized (see below)
  misc/         # assorted skills from various sources
```

## Groups

The `skills` CLI groups by the Claude Code plugin manifest at
`.claude-plugin/plugin.json`. Skills listed there render under the **Mattpocock**
group; anything else discovered (currently `misc/`) falls under **Other**.

To hide a work-in-progress skill from discovery/list/install, add
`metadata: { internal: true }` to its `SKILL.md` frontmatter (installable only
with `INSTALL_INTERNAL_SKILLS=1` or an explicit `--skill <name>`).

## Attribution

- `skills/mattpocock/*` forked from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT), then customized to change where domain/context/tracker docs are written. See `licenses/LICENSE.mattpocock`.
- `skills/misc/bro` from [dmmulroy/skills](https://github.com/dmmulroy/skills) (MIT). See `licenses/LICENSE.dmmulroy`.

Customizations to the forked skills are documented in `skills/mattpocock/CUSTOMIZATIONS.md`.
