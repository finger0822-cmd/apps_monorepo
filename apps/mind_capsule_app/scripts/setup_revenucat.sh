#!/bin/bash
# RevenueCat integration setup for MindCapsule
# - Ensure RevenueCat project and API keys are configured in the dashboard
# - iOS: Add API key in Xcode / Info.plist if needed
# - Android: Add API key in build.gradle or env if needed
set -e
echo "RevenueCat setup checklist:"
echo "1. Create project at https://app.revenuecat.com"
echo "2. Add iOS/Android apps and get API keys"
echo "3. Replace sk_test_placeholder in lib/services/revenue_cat_service.dart"
echo "4. Configure products/entitlements in RevenueCat dashboard"
echo "Done."
