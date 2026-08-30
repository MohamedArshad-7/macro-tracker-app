@echo off
echo 🚀 Building Macro Tracker for production...

REM Build the app
echo 📦 Building Flutter web app...
flutter build web --release --base-href="/macro-tracker-app/"

REM Check if build succeeded
if %errorlevel% neq 0 (
    echo ❌ Build failed!
    pause
    exit /b %errorlevel%
)

echo ✅ Build successful!

REM Replace Firebase config in build
echo 🔧 Injecting Firebase config...
powershell -Command "(Get-Content build/web/config.js) -replace 'REPLACE_API_KEY', '%FIREBASE_API_KEY%' | Set-Content build/web/config.js"
powershell -Command "(Get-Content build/web/config.js) -replace 'REPLACE_AUTH_DOMAIN', '%FIREBASE_AUTH_DOMAIN%' | Set-Content build/web/config.js"
powershell -Command "(Get-Content build/web/config.js) -replace 'REPLACE_PROJECT_ID', '%FIREBASE_PROJECT_ID%' | Set-Content build/web/config.js"
powershell -Command "(Get-Content build/web/config.js) -replace 'REPLACE_STORAGE_BUCKET', '%FIREBASE_STORAGE_BUCKET%' | Set-Content build/web/config.js"
powershell -Command "(Get-Content build/web/config.js) -replace 'REPLACE_MESSAGING_SENDER_ID', '%FIREBASE_MESSAGING_SENDER_ID%' | Set-Content build/web/config.js"
powershell -Command "(Get-Content build/web/config.js) -replace 'REPLACE_APP_ID', '%FIREBASE_APP_ID%' | Set-Content build/web/config.js"

echo ✅ Firebase config injected!

echo 📂 Build folder: build/web
echo 🚀 Ready to deploy to GitHub Pages!

pause