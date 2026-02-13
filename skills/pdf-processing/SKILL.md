---
name: pdf-processing
description: Extract, analyze, and process text content from PDF documents using pdftotext. Integrates with text-manipulation for comprehensive document processing workflows.
argument-hint: [operation] [pdf-file] [options]
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

## Overview

Extract, analyze, and process text content from PDF documents using pdftotext. Integrates with text-manipulation for comprehensive document processing workflows. Bridges PDF documents into text processing workflows with advanced analysis capabilities, structured data extraction, and seamless integration with existing text manipulation tools.

## Usage

```bash
/pdf-processing [operation] [pdf-file] [options]
```

# PDF Processing

## Installation Requirements

### Install pdftotext Utility

The skill requires the `pdftotext` utility from the [Poppler PDF rendering library](https://poppler.freedesktop.org/). Poppler is a mature, open-source PDF manipulation library used by many applications.

**Documentation**:
- [Poppler Project Homepage](https://poppler.freedesktop.org/)
- [pdftotext Manual Page](https://www.xpdfreader.com/pdftotext-man.html)
- [Poppler Command Line Tools](https://poppler.freedesktop.org/releases.html)

**macOS (Homebrew):**
```bash
brew install poppler
pdftotext -v  # Verify installation
```

**Ubuntu/Debian:**
```bash
sudo apt-get update && sudo apt-get install poppler-utils
pdftotext -v  # Verify installation
```

**CentOS/RHEL/Amazon Linux:**
```bash
sudo yum install poppler-utils  # or: sudo dnf install poppler-utils
pdftotext -v  # Verify installation
```

**From Source** (if package managers unavailable):
See [Poppler Installation Guide](https://poppler.freedesktop.org/releases.html) for building from source.

## Core Workflow

### Essential PDF Processing Steps (Most Common - 90% of Usage)

**1. Basic Text Extraction**
```bash
# Extract text from PDF with layout preservation
/pdf-processing --operation="extract" --input="document.pdf" --mode="layout" --output="extracted.txt"

# Quick raw text extraction for simple processing
/pdf-processing --operation="extract" --input="report.pdf" --mode="raw"
```

**2. Document Analysis**
```bash
# Analyze document structure and content
/pdf-processing --operation="analyze" --input="document.pdf" --level="basic"

# Full analysis for complex documents
/pdf-processing --operation="analyze" --input="complex_doc.pdf" --level="full" --output="analysis.json"
```

**3. Integration with Text Processing**
```bash
# Extract and then process with text-manipulation
/pdf-processing --operation="extract" --input="data.pdf" --output="extracted.txt"
# Then: /text-manipulation --operation="pattern-extract" --input="extracted.txt"
```

**Preconditions:**
- **pdftotext installed**: `brew install poppler` (macOS) or system package manager
- **Valid PDF files**: Readable PDF documents (not password-protected or corrupted)
- **File permissions**: Read access to PDF files, write access for output files

## Core Operations

### Basic Text Extraction

**Extract text from PDF with layout preservation:**
```bash
# Simple extraction with layout preservation
/pdf-processing --operation="extract" --input="document.pdf" --mode="layout" --output="document.txt"

# Smart extraction (auto-detects best method)
/pdf-processing --operation="extract-smart" --input="complex_document.pdf" --output="extracted.txt"

# Raw text extraction without formatting
/pdf-processing --operation="extract" --input="document.pdf" --mode="raw" --output="raw_text.txt"
```

### Content Analysis

**Comprehensive PDF analysis:**
```bash
# Basic content analysis
/pdf-processing --operation="analyze" --input="report.pdf" --level="basic" --output="report_analysis.json"

# Full analysis with advanced metrics
/pdf-processing --operation="analyze" --input="document.pdf" --level="full" --output="full_analysis.json"

# Document classification and structure analysis
/pdf-processing --operation="classify" --input="unknown_document.pdf" --output="classification.json"
```

### Structured Data Extraction

**Extract specific patterns from PDF content:**
```bash
# Extract common data patterns
/pdf-processing --operation="extract-structured" --input="contacts.pdf" --patterns="email,phone,date-iso" --format="json"

# Extract financial data patterns
/pdf-processing --operation="extract-structured" --input="statement.pdf" --patterns="currency,date-us,percentage" --format="csv"

# Custom pattern extraction
/pdf-processing --operation="extract-structured" --input="logs.pdf" --patterns="[A-Z]{3}-[0-9]{4},ERROR.*" --format="json"
```

### Document Sectioning

**Split PDF content into logical sections:**
```bash
# Split by headers and structure
/pdf-processing --operation="split-sections" --input="manual.pdf" --method="headers" --output-prefix="manual_section"

# Split by page breaks
/pdf-processing --operation="split-sections" --input="report.pdf" --method="pages" --output-prefix="report_page"

# Split by paragraph breaks
/pdf-processing --operation="split-sections" --input="article.pdf" --method="paragraphs" --output-prefix="article_para"
```

### Batch Processing

**Process multiple PDFs:**
```bash
# Batch extract all PDFs in directory
/pdf-processing --operation="batch-extract" --pattern="documents/*.pdf" --mode="extract-clean" --output-dir="extracted_text"

# Parallel batch processing for large sets
/pdf-processing --operation="batch-parallel" --pattern="reports/**/*.pdf" --mode="full-analysis" --parallel="4" --output-dir="analyzed"

# Batch structured data extraction
/pdf-processing --operation="batch-structured" --pattern="invoices/*.pdf" --patterns="currency,date-us" --output-dir="invoice_data"
```

## Integration with Text Manipulation

### Pipeline Integration

**Seamless workflow with text-manipulation skill:**
```bash
# Extract PDF and immediately process text
/pdf-processing --extract="document.pdf" | text-manipulation --operation="normalize" --cleanup="whitespace,encoding"

# PDF → structured data → analysis pipeline
/pdf-processing --operation="extract-structured" --input="data.pdf" --patterns="email,phone" --format="json" | \
  json-management --operation="validate" --schema="contacts_schema.json"

# Performance review analysis (as used in this session)
/pdf-processing --operation="extract" --input="performance_review.pdf" --mode="layout" | \
  text-manipulation --operation="extract" --patterns="improvement,strength,goal,Q[1-4]" --format="json"
```

### Common Workflow Patterns

**Document processing workflows:**
```bash
# Clean and analyze document content
pdf-processing --extract-smart="technical_doc.pdf" | \
  text-manipulation --operation="normalize" --cleanup="whitespace,line-endings" | \
  text-manipulation --operation="extract" --patterns="url,email,ip" --format="json"

# Financial document processing
pdf-processing --operation="extract-structured" --input="statement.pdf" --patterns="currency,percentage" | \
  csv-management --operation="aggregate" --group-by="pattern_type"

# Log analysis from PDF reports
pdf-processing --extract="system_report.pdf" | \
  text-manipulation --operation="analyze-logs" --filter="ERROR|WARN" --format="markdown"
```

## Behavior

When invoked, the skill will:

1. **Validate Prerequisites**: Check for `pdftotext` utility and provide installation guidance if missing
2. **Process Input**: Extract text from PDF using optimal method based on content structure
3. **Execute Operation**: Perform requested analysis, extraction, or processing
4. **Generate Output**: Create formatted results in specified format (text, JSON, CSV)
5. **Integration Support**: Provide output compatible with text-manipulation and other skills

### Input Validation

The skill performs comprehensive input validation:
- **PDF File Validation**: Checks file readability, format, and corruption
- **Dependency Check**: Verifies `pdftotext` availability with helpful installation guidance
- **Parameter Validation**: Ensures extraction modes and output formats are supported
- **Resource Check**: Validates output directory permissions and available disk space

### Error Handling

Robust error handling with actionable guidance:
- **Installation Issues**: Provides platform-specific installation commands with links to official documentation
- **File Access Problems**: Clear instructions for permission resolution
- **Corrupted PDFs**: Suggests alternative approaches or manual intervention
- **Resource Constraints**: Guidance for processing large files or batch operations

## Quality Assurance

### Extraction Quality Assessment

The skill automatically assesses extraction quality:
- **Content Completeness**: Validates extracted text against expected document structure
- **Character Encoding**: Detects and reports encoding issues
- **Layout Preservation**: Evaluates how well original formatting was maintained
- **Data Integrity**: Checks for garbled text or missing content sections

### Output Validation

All outputs are validated before completion:
- **Format Compliance**: JSON/CSV outputs validated for syntax correctness
- **Content Sanity**: Basic checks for reasonable content volume and structure
- **Integration Compatibility**: Ensures output format works with downstream text-manipulation operations

## Specialized Workflows

### Performance Review Analysis
**Process annual/quarterly performance reviews:**
```bash
# Extract performance metrics and feedback
/pdf-processing --operation="performance-review" --input="annual_review.pdf" --output="review_analysis"
```

### Financial Document Processing
**Extract financial data patterns:**
```bash
# Process statements, invoices, reports
/pdf-processing --operation="financial-analysis" --input="statement.pdf" --output="financial_data.csv"
```

### Technical Documentation Processing
**Extract technical content and references:**
```bash
# Process manuals, API docs, technical reports
/pdf-processing --operation="technical-doc" --input="api_manual.pdf" --output="tech_references.json"
```

## Quick Reference

### Essential PDF Processing Commands

| Operation | Purpose | Example Command |
|-----------|---------|-----------------|
| **Basic Extract** | Simple text extraction | `/pdf-processing --operation="extract" --input="doc.pdf" --mode="layout"` |
| **Smart Extract** | Auto-optimized extraction | `/pdf-processing --operation="extract-smart" --input="doc.pdf"` |
| **Content Analysis** | Document structure analysis | `/pdf-processing --operation="analyze" --input="doc.pdf" --level="basic"` |
| **Structured Extract** | Pattern-based data extraction | `/pdf-processing --operation="extract-structured" --patterns="email,phone"` |
| **Batch Process** | Multiple PDF processing | `/pdf-processing --operation="batch-extract" --pattern="*.pdf"` |

### Common Extraction Modes

| Mode | Best For | Output Quality | Use Case |
|------|----------|----------------|-----------|
| `raw` | Simple text documents | Fast, basic | Quick content review |
| `layout` | Formatted documents | Good spacing | Reports, documentation |
| `smart` | Mixed content types | Auto-optimized | Unknown document types |
| `structured` | Data extraction | Pattern-focused | Forms, tables, data sheets |

### Integration Patterns with Text Manipulation

**PDF → Text Processing Pipeline:**
```bash
# Extract and clean
pdf-processing extract doc.pdf | text-manipulation normalize --cleanup="whitespace"

# Extract structured data
pdf-processing extract-structured invoices/*.pdf --patterns="currency,date" | csv-management aggregate

# Document analysis workflow
pdf-processing analyze report.pdf | text-manipulation extract --patterns="ERROR|WARN"
```

### Installation Quick Reference

| Platform | Installation Command | Verification |
|----------|---------------------|--------------|
| **macOS** | `brew install poppler` | `pdftotext -v` |
| **Ubuntu** | `sudo apt-get install poppler-utils` | `pdftotext -v` |
| **CentOS** | `sudo yum install poppler-utils` | `pdftotext -v` |
| **Windows** | [Manual installation](https://blog.alivate.com.au/poppler-windows/) | `pdftotext -v` |

### Troubleshooting Quick Fixes

| Issue | Solution | Command/Action |
|-------|----------|----------------|
| **Tool not found** | Install poppler | `brew install poppler` |
| **Corrupted PDF** | Try different mode | `--mode="raw"` instead of `--mode="layout"` |
| **Large file timeout** | Process in sections | `--operation="split-sections"` first |
| **Encoding issues** | Use text-manipulation cleanup | `| text-manipulation normalize --cleanup="encoding"` |
| **Permission denied** | Check file access | `chmod 644 file.pdf` |

### Performance Guidelines

| File Size | Processing Method | Expected Time | Memory Usage |
|-----------|------------------|---------------|--------------|
| **< 1MB** | Direct processing | < 1 second | Low |
| **1-10MB** | Standard extraction | 1-5 seconds | Medium |
| **10-50MB** | Section-based processing | 5-30 seconds | Medium-High |
| **50MB+** | Batch with parallel processing | Variable | High |

## Advanced Patterns

### Complex Document Processing Workflows

**Multi-Format Document Analysis:**
Advanced workflows handle mixed document types with intelligent processing selection, format detection, and optimization strategies for different content structures.

**Large-Scale Document Mining:**
Enterprise-scale PDF processing with distributed processing patterns, content indexing, and advanced pattern recognition for document classification and data extraction.

**Document Comparison and Versioning:**
Advanced comparison techniques for PDF document versions, change detection, and differential analysis with structured output for version control integration.

### Advanced Extraction Techniques

**OCR Integration for Scanned Documents:**
Advanced handling of image-based PDFs through OCR preprocessing, quality enhancement, and post-processing validation to ensure accurate text extraction from scanned content.

**Table and Structure Recognition:**
Sophisticated table detection and extraction with column alignment preservation, header recognition, and complex table structure handling for accurate data extraction.

**Multi-Language Document Processing:**
International document processing with character encoding detection, language-specific text processing, and Unicode normalization for global document compatibility.

### Performance Optimization Strategies

**Parallel Batch Processing:**
Advanced batch processing with work queue management, parallel execution optimization, and resource allocation strategies for high-volume document processing operations.

**Memory-Efficient Large File Handling:**
Streaming processing techniques for very large PDFs, memory footprint optimization, and disk-based intermediate storage for resource-constrained environments.

**Caching and Resume Capabilities:**
Intelligent caching of extraction results, partial processing state preservation, and resume functionality for interrupted large-scale processing operations.

### Integration Architecture Patterns

**Microservice Integration:**
Advanced integration patterns for enterprise document processing services with API exposure, service discovery, and distributed processing coordination.

**Real-Time Processing Pipelines:**
Event-driven document processing with queue integration, real-time extraction triggers, and streaming output for immediate downstream processing.

**Quality Assurance and Validation:**
Comprehensive quality validation frameworks with extraction accuracy metrics, content verification protocols, and automated quality reporting.

### Security and Compliance Patterns

**Secure Document Processing:**
Advanced security patterns for sensitive document handling with encryption support, access logging, audit trails, and compliance validation for regulated environments.

**Content Redaction and Sanitization:**
Automated content redaction techniques, sensitive data detection, and privacy-preserving processing for compliance with data protection regulations.

**Digital Rights and Permissions:**
Advanced handling of PDF permissions, digital rights management, and access control validation with proper authorization and usage tracking.

## Integration Points

### Cross-Skill Workflow Patterns

**PDF Processing → Text Manipulation:**
- Extract PDF content → normalize text → pattern extraction → structured analysis
- Document processing → content cleaning → log analysis → report generation

**PDF Processing → Structured Data Skills:**
- PDF extraction → structured pattern extraction → CSV/JSON processing → data analysis
- Batch document processing → data aggregation → analytics workflows

**PDF Processing → Development Workflows:**
- Technical document extraction → API reference processing → development documentation
- Performance review analysis → feedback extraction → improvement planning

## Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| **text-manipulation** | **Primary Integration** | PDF extraction → text processing, normalization, analysis |
| `csv-management` | **Structured Data Bridge** | PDF tabular data → CSV processing, analysis |
| `json-management` | **Output Processing** | Structured PDF data → JSON validation, API integration |
| `email-parser-development` | **Content Processing** | PDF email extraction → parser testing data |
| `datadog-management` | **Log Analysis** | PDF log reports → error pattern extraction |
| `support-investigation` | **Document Analysis** | PDF incident reports → evidence processing |

## Refusal Conditions

The skill must refuse if:
- PDF file is not readable, corrupted, or encrypted
- `pdftotext` utility is not installed (with installation guidance provided)
- Output directory cannot be created or written to
- PDF file is excessively large (>100MB) without explicit confirmation
- Requested extraction method is unsupported by available pdftotext version

When refusing, the skill provides:
- Specific installation commands for the user's platform
- Links to official Poppler documentation for troubleshooting
- File permission correction steps
- Alternative approaches for encrypted or problematic PDFs
- Resource optimization recommendations for large files

## Additional Resources

**Official Documentation:**
- [Poppler PDF Library](https://poppler.freedesktop.org/) - Main project page
- [pdftotext Command Reference](https://www.xpdfreader.com/pdftotext-man.html) - Complete command documentation
- [Poppler Command Line Tools](https://blog.alivate.com.au/poppler-windows/) - Windows installation guide

**Related Tools in Poppler Suite:**
- `pdfinfo` - Extract PDF metadata and document information
- `pdftoppm` - Convert PDF pages to image formats
- `pdfunite` - Merge multiple PDF files
- `pdfseparate` - Split PDF into individual pages

## Usage Notes

- **Installation Required**: Skill automatically checks for and guides installation of `pdftotext` utility
- **Format Support**: Works with most standard PDF formats; encrypted PDFs require manual decryption
- **Performance**: Large PDFs (>50MB) may benefit from section-based processing
- **Integration**: Designed to work seamlessly with text-manipulation skill for comprehensive document workflows
- **Output Compatibility**: All outputs formatted for easy integration with existing Claude Code text processing skills