-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

-keep class com.reactnativestripesdk.pushprovisioning.** { *; }
-dontwarn com.reactnativestripesdk.pushprovisioning.**

# Keep Stripe payment sheet and related dependencies that may be used at runtime
-keep class com.stripe.android.payments.** { *; }
-dontwarn com.stripe.android.payments.**

# Keep any generated Kotlin metadata referenced via reflection
-keepclassmembers class kotlin.Metadata { *; }

