# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Quarto website project for the CRGE Historical Database, documenting Christian missionary history and religious agency in East Asia. The site uses R for dynamic content generation from a CSV data source and outputs to `_site/` for static hosting.

## Development Commands

```bash
# Render the entire website
quarto render

# Preview during development (with live reload)
quarto preview

# Render specific output format
quarto render --to html

# Check project structure
quarto check
```

Note: Quarto CLI must be installed. If not available, this project can also be rendered through RStudio.

## Architecture and Data Flow

### Content Generation System
- **Single data source**: `data.csv` (4MB+ file with columns: area, topic, period, section, text_en, text_zh)
- **Template-based pages**: Each `.qmd` file loads the CSV and filters by area/period
- **Hierarchical content**: Data flows as Topic → Section → Text content
- **Bilingual support**: Both English (`text_en`) and Chinese (`text_zh`) content available

### File Structure
- `_quarto.yml`: Main configuration (book structure, themes, chapters)
- `data.csv`: Single source of truth for all historical content
- `en/[region]/[period].qmd`: Country/period-specific content pages
- `zh/`: Chinese language directory (currently unused)
- Template pattern in `.qmd` files:
  ```r
  # Standard setup for all content pages
  area <- "Country"
  period <- "YYYY-YYYY"
  df <- read.csv("../../data.csv")
  df_sub <- df %>% filter(area == area, period == period)
  ```

### Geographic and Temporal Organization
- Areas: China, Manchuria, Hong Kong, Taiwan, Japan, Korea, 
- Periods (within each area): Pre-1900, 1900-1910, 1910-1920, 1920-1930, 1930-1940, 1940-1950, 1950-1960, 1960-1970, 1970-1980, 1980-1990, 1990-2000
- Topics (within each period): Agency, Context
- Section within Agency = (
  "Christian or Pro-Christian Leaders",
  "Christian or Pro-Christian Organizations",
  "Christian or Pro-Christian Events/Movements",
  "Key theological, doctrinal, or ecclesiastic issues in this decade, if any",
  "Anti-Christian Leaders (including competitors from secularisms and other religions who argued or campaigned against Christianity)",
  "Anti-Christian Organizations (including competing organizations of secularisms and other religions that campaigned against Christianity)",
  "Anti-Christian Events/Movements (including competing events/movements against Christianity)",
  "Bibliography"
)
- Sections within Context = c(
  "Governmental Regulations on Religion and Legal Cases",
  "Social Hostility toward Christianity",
  "Geopolitical dynamics and International Relationships",
  "Bibliography"
)
- **Content structure**: Each page dynamically generates sections based on CSV data

## Configuration and Content Management

### Adding New Pages
1. Create `.qmd` file in `en/[region]/` directory following existing template
2. Update `_quarto.yml` navbar to include new page in website navigation
3. Ensure CSV data exists for the area/period combination

### Data Structure Requirements
- CSV must maintain exact column structure: `area,topic,period,section,text_en,text_zh`
- Area names must match directory structure in `en/`
- Period names must match filename patterns (e.g., "1950-1960" → `1950-1960.qmd`)

### Known Issues
- `_quarto.yml` only includes Korea pages despite other regions having content
- Some index files are empty and need content generation setup

## R Dependencies
Required R packages for content generation:
- `dplyr`: Data filtering and manipulation
- `glue`: String interpolation for dynamic content