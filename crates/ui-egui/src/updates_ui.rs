//! Application updates are managed centrally by the owner.
//!
//! Keep the host entry points as no-ops for compatibility, but never construct an
//! updater, contact a release service, display an update dialog, or self-replace
//! the executable. This preserves reviewed local customizations across updates.

use crate::WordApp;

impl WordApp {
    /// Compatibility entry point; the central manager owns update checks.
    #[cfg(not(target_arch = "wasm32"))]
    pub fn set_startup_update_check(&mut self, _on: bool) {}
}

pub(crate) fn check(_app: &mut WordApp) {}
