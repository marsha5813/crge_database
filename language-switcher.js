// Language switcher functionality for CRGE Historical Database
// Dynamically switches between EN and ZH versions of pages

function switchLanguage(targetLang) {
    const currentPath = window.location.pathname;
    let newPath;
    
    // Remove leading slash and any trailing .html for easier processing
    let cleanPath = currentPath.replace(/^\/|\.html$/g, '');
    
    // Handle top-level index.html case
    if (cleanPath === '' || cleanPath === 'index') {
        newPath = targetLang === 'zh' ? '/zh/index.html' : '/en/index.html';
    }
    // Handle en/ paths - switch to zh/
    else if (cleanPath.startsWith('en/')) {
        newPath = '/' + cleanPath.replace('en/', 'zh/') + '.html';
    }
    // Handle zh/ paths - switch to en/
    else if (cleanPath.startsWith('zh/')) {
        newPath = '/' + cleanPath.replace('zh/', 'en/') + '.html';
    }
    // Handle other cases - assume we want to add language prefix
    else {
        newPath = targetLang === 'zh' ? '/zh/' + cleanPath + '.html' : '/en/' + cleanPath + '.html';
    }
    
    // Navigate to the new URL
    window.location.href = newPath;
}

// Function to get current language from URL
function getCurrentLanguage() {
    const path = window.location.pathname;
    if (path.includes('/zh/')) {
        return 'zh';
    } else if (path.includes('/en/')) {
        return 'en';
    } else {
        // Default to English for top-level pages
        return 'en';
    }
}

// Function to update language switcher text based on current page
function updateLanguageSwitcher() {
    const currentLang = getCurrentLanguage();
    const switcher = document.querySelector('#nav-menu-en--中文 .menu-text');
    
    if (switcher) {
        // Update the switcher text to show current language first
        switcher.textContent = currentLang === 'zh' ? '中文 / EN' : 'EN / 中文';
    }
}

// Initialize when page loads
document.addEventListener('DOMContentLoaded', function() {
    updateLanguageSwitcher();
    
    // Add click handlers to language switcher dropdown items
    const englishLink = document.querySelector('a[href*="en/index"]');
    const chineseLink = document.querySelector('a[href*="zh/index"]');
    
    if (englishLink) {
        englishLink.addEventListener('click', function(e) {
            e.preventDefault();
            switchLanguage('en');
        });
    }
    
    if (chineseLink) {
        chineseLink.addEventListener('click', function(e) {
            e.preventDefault();
            switchLanguage('zh');
        });
    }
});