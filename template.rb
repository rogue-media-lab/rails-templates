# 1. Define CSS Content
tailwind_css_content = <<-CSS
@import "tailwindcss";

@theme {
  --color-ivory-50: #fefdfb;
  --color-ivory-100: #fdf9f3;
  --color-ivory-200: #faf2e7;
  --color-ivory-300: #f6e8d7;
  --color-ivory-400: #f0d9c3;
  --color-ivory-500: #e8c7a6;
  --color-ivory-600: #d4a574;
  --color-ivory-700: #b8834a;
  --color-ivory-800: #8f6238;
  --color-ivory-900: #6b4a2a;

  --color-pastel-pink: #f8d7da;
  --color-pastel-lavender: #e2d5f1;
  --color-pastel-mint: #d1f2eb;
  --color-pastel-peach: #fdebd0;
  --color-pastel-sky: #cce7ff;
  --color-pastel-sage: #e8f5e8;

  --font-family-sans: 'Inter var', ui-sans-serif, system-ui, sans-serif;
}

@keyframes fadeIn {
  0% { opacity: 0; }
  100% { opacity: 1; }
}

@keyframes slideUp {
  0% { transform: translateY(10px); opacity: 0; }
  100% { transform: translateY(0); opacity: 1; }
}

@theme {
  --animate-fade-in: fadeIn 0.5s ease-in-out;
  --animate-slide-up: slideUp 0.3s ease-out;
}
CSS

say "🚀 Setting up custom Tailwind CSS theme and documentation...", :cyan

# 2. Handle the CSS File
# Note: The path 'app/assets/tailwind/application.css' is used for consistency
# as it's referenced in the documentation content below.
create_file 'app/assets/tailwind/application.css', tailwind_css_content, force: true
say "✅ The Tailwind theme has been applied.", :green

# 3. Define MARKDOWN Content
tailwind_doc_content = <<-MARKDOWN
# Tailwind CSS Theme Configuration

This file outlines the custom theme properties added to your Tailwind CSS setup via the `tailwind-rails` gem.

## Location

The theme configuration is located in: `app/assets/tailwind/application.css`

## Modifying the Theme

You can modify the theme directly within the `@theme` block in the `application.css` file.

### Colors

Custom colors are defined using CSS variables. You can add new variables or change existing ones.

**Example:**
@theme {
  --color-ivory-50: #fefdfb;
  /* ... other colors */
  --color-new-brand-blue: #0055a4;
}

To use these colors in your HTML, apply them using Tailwind's arbitrary value syntax:

<div class="bg-[--color-ivory-50] text-[--color-new-brand-blue]">...</div>

### Fonts

The default sans-serif font family is set. You can change it by modifying the `--font-family-sans` variable.

@theme {
    --font-family-sans: 'Your-New-Font', ui-sans-serif, system-ui, sans-serif;
}

### Animations

Custom keyframes (`fadeIn`, `slideUp`) and animation utilities are defined. You can add more following the same pattern.

@keyframes yourNewAnimation {
  /* ... */
}

@theme {
  --animate-your-new-animation: yourNewAnimation 1s ease;
}

Use it in your HTML like this:

<div class="animate-[--animate-your-new-animation]">...</div>

For more information on theming with `tailwind-rails`, refer to the official documentation.
MARKDOWN

# 4. Create the Markdown Documentation File
create_file 'tailwind-config.md', tailwind_doc_content
say "📄 The Tailwind documentation has been created.", :green
