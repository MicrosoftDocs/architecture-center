function Get-CasingExpressions
{
    return @(
        "Azure Arc",
        "Azure Lighthouse",
        "Azure Reservations",
        # "ext steps",
        # "anagement groups",       # TODO: Handle before and after conditions.
        # "ole-based",
        "Cloud Adoption Framework",
        "Cosmos DB"
        "cSpell",
        "DevOps",
        "GitHub",
        "MariaDB",
        "MongoDB",
        # "MySQL",          # TODO: Ignore local link paths
        "Patterns?\]",
        "PolyBase",
        "PostgreSQL",
        "Pluralsight",
        "SKU",
        " vs "
        "<endoflist>"
    )
}

function Get-InvalidTermExpressions {

    return @(
        "3rd",
        "a [aei](?!dds|nd B)",          # Use 'an' instead.
        "a number of",
        "a the",
        "( a (one|two|three|four|five) )(?!Microsoft)",
        "AAD",
        "AD-FS",
        "ADFS",
        "ad-hoc",
        "adhoc",
        "all of your",
        "and/or",
        "auto-(?!enroll)"       # 'auto-enroll' is allowed.
        "business'[^s]",
        "CAF",
        "carry out",
        "check list",
        "Cosmos-DB",
        "CosmosDB",
        "cSpell:disable",
        "data center",
        "data centers",
        "e\.g\.",
        "express route",
        "getting started(?!( guide| guidance|\*\*|\]))",
        "git hub",
        "hte",
        "i\.e\.",
        "impacted",
            "could impact",
            "may impact",
            "might impact",
            "not impact",
        "in case of",
        "infra",
        "life cycle",
        "low ops",
        "Maria.DB",
        "MFA",
        "multi-(?!factor|model|shard)",
        "no ops",
        "non-(?!business|cloud|DR|EA|mission|IaaS|internet|PaaS)",
        "northstar",
        "off-site",
        "on-board",
            "on-boarded",
            "on-boarding",
        "on going",
            "on-going",
        "on-prem",
            "on-premise",
        # "outlines",           # TODO: Use 'shows' or 'discusses'
        #"outlined",             # Use 'showed' or 'discussed'
        "ops management",
        "planing",
        "pre-(?!CCoE|promotion)",
        "re-(?!create|created|creating)",
        "Responsible/Supporting",
        "separation of duty",
        "short and long",
        "short and mid",
        "skillset",
            "skillsets",
        "teh",
        "the best practices (?!defined|outlined|in)"
        "w\/",
        "with title"
        "<endoflist>"
    )
}

function Get-MalformedLinkExpressions
{
    return @(

            "$(Get-RegexForDocsUrl)\.md",
            "\([^~\.][^\)]*\.(md|yml|png|jpg|svg)\)",
            "\]\(\.[a-zA-Z0-9-\/\._]*\)(?<!(md|ml|ng|vg|pg)\))",
            "\[[^\]]*\]\(/azure",
            "(?<!social_image_url): /azure/architecture",
            "\(/azure/architecture",
            "\(\/",
            # "/\)",                            # TODO: Re-evaluate.
            "(?<!portal|account|cloudapp|cosmos|notebooks)[\./]azure\.com(?!mands)",      # Use 'azure.microsoft.com'
            "ms\.portal",                                       # Don't use internal "ms." prefix
            "toc=[^/]",                                         # Use a relative reference for a contextual TOC.
            "toc=/azure/(?!cloud-adoption-framework)"           # Currently, no expected contextual TOCs other than AAC and CAF.
            # "href: https://docs\.microsoft\.com/(?!cloud-adoption-framework/|learn/|/assessments).*[^n]$",   # TODO: Use TOC redirects for other Docs content
            "(?i)http://[a-z]*\.microsoft\.com",                      # Use HTTPS for all Microsoft URLs.
            "href: https://(?!docs\.microsoft\.com\/).*toc=",       # Don't use a contextual TOC for non-Docs content
            "href: https://docs\.microsoft\.com/learn/.*toc=",   # Don't use a contextual TOC for Learn content
            "app.pluralsight.com",                              # Use www.pluralsight.com/courses/...
            "www.pluralsight.com\/library",                     # Ibid
            # "``` ?[A-Z]"
            "\]\(\.[^ \)#]*[\)#](?<!\.md[\)#]|\.(yml|png|jpg|svg)[\)#])",    # Local links require a known extension.
            "<endoflist>"
    )
}

function Get-PunctuationExpressions
{
    return @(
        "(?i)[a-z] {2,}[a-z]"               # One space between words
        "(?<=[a-z])\.  (?=[A-Z])",          # Use only one space after a sentence
        "^ *\*\s",                          # Use hyphens for bullet lists
        "^[^#-].*vs\.",                     # Use "versus" in non-headings
        " & (?![A-Z])",
        " &/",
        "At times ",
        "But, ",
        "However ",
        # "^ *[^a-z#:$`].*[a-z]$","         # TODO: Sentences should end with periods.
        "<endoflist>"
    )
}

function Get-FormattingExpressions
{
    return @(
        " {1,}$",               # No spaces at the end of a line.
        "^ *\* ",               # Bullet lists should use hyphens.
        "\[[a-z][^\]]*$",       # Fix link descriptions split across lines.
        "[a-z]\) - ",           # TODO: Use colons after parentheses?
        "toc=.*%2[Ff]",
# TODO REINSTATE        "description: [A-Za-z-]*ing",
# TODO REINSTATE        'title: "?[A-Za-z-]*ing',
        "Cloud [A-Z][a-z]* [Tt]eams?",
        "^\|(?![- ])",          # Table cells should have at least one space around pipes for readability.
        "(?<![- ])\|$",         # ibid
        #"[^ -]\|",             # ibid
        #"\|[^ -]",             # ibid
        # \|([^\|]){600,}\|     # TODO: Find bullet lists and long sentences in tables
# TODO REINSTATE        "^ *- .*: \[.*\):",     # End these headings with a period instead.
        "-w-",
        "<endoflist>"
    )
}
