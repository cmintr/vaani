# Appium harness examples

The private app uses Appium to drive voice and tool flows on a real Android
device. This public folder contains only the validation contract.

## Voice-command pass contract

A reminder voice turn passes only when all are true:

- Transcript or equivalent route signal observed.
- Tool invocation observed.
- Reminder database row count increases.
- Runtime feedback marker appears.
- Duration stays under the configured latency ceiling.

This avoids weak UI-only validation and catches regressions where the assistant
speaks but no durable side effect occurs.

