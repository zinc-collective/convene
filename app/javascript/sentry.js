import * as Sentry from "@sentry/browser";

export function initializeSentry() {
  const dsn = document.head.querySelector("meta[name=sentry_dsn]").content;
  if (!dsn) {
    return;
  }

  Sentry.init({
    dsn: dsn,
    integrations: [
      Sentry.browserTracingIntegration(),
      Sentry.captureConsoleIntegration(),
    ],
    release: document.head.querySelector("meta[name=release_tag").content,

    // Set tracesSampleRate to 1.0 to capture 100%
    // of transactions for performance monitoring.
    // We recommend adjusting this value in production
    tracesSampleRate: 1.0,
  });
}
