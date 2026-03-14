# Archive: JOE's Own Editor (Mercurial Era)

This directory contains the final, "frozen" state of the Mercurial repository used for **JOE** from **3.8 through most of the 4.0 series**. 

While the current live Git repository includes the migrated history from CVS and Mercurial, this bundle is preserved here as a technical relic to ensure the original Mercurial structure (branches, tags, and metadata) remains accessible in its native format.

## Archive Content
- `joe-editor.hg`: A full Mercurial bundle containing all changesets, including the imported CVS history and the 4.x development branches.
- **Migration Note**: This repository served as the bridge between the legacy CVS era and the current Git era.

## How to "Rehydrate" (Restore)
If you need to verify the original Mercurial metadata or branches as they existed prior to the Git migration:

1. **Clone the Bundle**:
   ```bash
   hg clone joe-relic.hg joe-editor-mercurial
   ```
