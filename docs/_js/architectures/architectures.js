function unCheck(checkid) {
    $("#"+checkid).remove();
    $("."+checkid).prop("checked", false );
    updateUrlBar(getQuery(false, 1))
}

function toggle(object, forceExpand) {
    if (!object) object = this;
    if (!forceExpand) forceExpand = false;
    
    var newObject;
    if (object.currentTarget) {
        newObject=object.currentTarget;
    } else {
        newObject=object;
    }

    var controls = $("#"+$(newObject).attr('aria-controls'));
    var current = JSON.parse($(newObject).attr('aria-expanded'));
    var expand;
    if (forceExpand) {
        expand = !forceExpand;
    } else {
        expand = !current;
    }

    $(newObject).attr('aria-expanded', (expand).toString());
    controls.css('max-height', expand ? '0px' : '100vh');
    controls.css('opacity', expand ? '0' : '1');
    controls.css('transition', 'max-height 300ms ease-in-out, opacity 300ms ease-in-out');
    controls.css('overflow', 'hidden');
    controls.css('hidden', false);
    var chevronAdd = expand ? "docon-chevron-up-light" : "docon-chevron-down-light";
    var chevronRemove = expand ? "docon-chevron-down-light" : "docon-chevron-up-light";
    controls.find(".expanded-indicator").removeClass(chevronRemove).addClass(chevronAdd);
}

Handlebars.registerHelper("math", function(lvalue, operator, rvalue, options) {
    lvalue = parseFloat(lvalue);
    rvalue = parseFloat(rvalue);
        
    return {
        "+": lvalue + rvalue,
        "-": lvalue - rvalue,
        "*": lvalue * rvalue,
        "/": lvalue / rvalue,
        "%": lvalue % rvalue
    }[operator];
});

Handlebars.registerHelper('ifCond', function (v1, operator, v2, options) {
    switch (operator) {
        case '==':
            return(v1 == v2) ? options.fn(this) : options.inverse(this);
        case '===':
            return(v1 === v2) ? options.fn(this) : options.inverse(this);
        case '!=':
            return(v1 != v2) ? options.fn(this) : options.inverse(this);
        case '!==':
            return(v1 !== v2) ? options.fn(this) : options.inverse(this);
        case '<':
            return(v1 < v2) ? options.fn(this) : options.inverse(this);
        case '<=':
            return(v1 <= v2) ? options.fn(this) : options.inverse(this);
        case '>':
            return(v1 > v2) ? options.fn(this) : options.inverse(this);
        case '>=':
            return(v1 >= v2) ? options.fn(this) : options.inverse(this);
        case '&&':
            return(v1 && v2) ? options.fn(this) : options.inverse(this);
        case '||':
            return(v1 || v2) ? options.fn(this) : options.inverse(this);
        default:
            return options.inverse(this);
    }
});

Handlebars.registerHelper('showPage', function (num, small, big, not, options) {
    if ( num < small || num > big || num == not || num == not-1 || num == not+1 ) {
        return options.fn(this);
    } else {
        return options.inverse(this);
    }
});

Handlebars.registerHelper('elips', function (num, small, big, current, options) {
    if ( (current > small && num == small+1) || (current < big && num == big-1)) {
        return options.fn(this);
    } else {
        return options.inverse(this);
    }
});

Handlebars.registerHelper('spaceDelim', function (items, options) {
    return options.fn(items.join(' '));
});

Handlebars.registerHelper('commaDelim', function (items, options) {
    return options.fn(items.join(','));
});

Handlebars.registerHelper('if', function (conditional, options) {
    if (conditional) {
        return options.fn(this);
    }
});

Handlebars.registerHelper('times', function(n, block) {
    var accum = '';
    for(var i = 1; i < n+1; ++i)
        accum += block.fn(i);
    return accum;
});

Handlebars.registerHelper('ifIn', function(elem, list, options) {
    if(list.indexOf(elem) > -1) {
      return options.fn(this);
    }
    return options.inverse(this);
});

Handlebars.registerHelper("switch", function(value, options) {
    this._switch_value_ = value;
    var html = options.fn(this); // Process the body of the switch block
    delete this._switch_value_;
    return html;
});

Handlebars.registerHelper("case", function(value, options) {
    if (value == this._switch_value_) {
        return options.fn(this);
    }
});

var refineString = [
'    {{#each categories as |category|}}{{#ifCond category.stub \'!=\' "hidden" }}',
'<div data-bi-name="{{ category.stub }}_facet" class="has-border-top">',
'    <button',
'        data-bi-name="expander"',
'        class="button expander-button has-inner-focus level is-mobile is-text is-undecorated is-fullwidth has-border-none has-margin-none is-large has-padding-left-medium"',
'        aria-expanded="false"',
'        aria-controls="{{ category.stub }}_facet"',
'    >',
'        <span class="has-text-weight-semibold is-size-7">{{ category.category }}</span>',
'        <span class="icon" aria-hidden="true">',
'            <span class="docon docon-chevron-up-light expanded-indicator"></span>',
'        </span>',
'    </button>',
'    <div id="{{ category.stub }}_facet" category="{{ category.stub }}" class="panel-body">',
'        <ul class="has-margin-none has-padding-top-none has-padding-bottom-small has-padding-left-medium">',
'        {{#each category.items as |item|}}',
'            <li class="is-unstyled">',
'                <label class="checkbox is-small has-padding-bottom-extra-small">',
'                    <input id="cb-dotnet" class="{{ item.friendly-name }}" name="{{ category.stub }}" value="{{#spaceDelim item.tags}}{{this}}{{/spaceDelim}}" friendly-name="{{ item.friendly-name }}" type="checkbox" onchange="updateUrlBar(getQuery(false, 1))">',
'                    <span class="checkbox-check" role="presentation"></span>',
'                    <span class="checkbox-text">{{ item.name }}</span>',
'                </label>',
'            </li>',
'        {{/each}}',
'        </ul>',
'    </div>',
'</div>{{/ifCond}}',
'{{/each}}'].join('');
var refineTemplate = Handlebars.compile(refineString);


var cardString = ['{{#each articles as |article|}}',
'<li class="grid-item" data-pivot="{{#spaceDelim article.tags}}{{this}}{{/spaceDelim}}">',
'<article class="card">',
'    <div class="card-header has-margin-top-small" aria-hidden="true">',
'        <figure class="image diagram">',
'            <a href="{{ article.http_url }}"><img src="{{ article.image }}"',
'            class="diagram"',
'            alt="Architecture Diagram"',
'            data-linktype="relative-path"></a>',
'        </figure>',
'    </div>',
'    <div class="card-content">',
'        <p class="card-content-super-title">',
'    {{#switch article.type}} ',
'        {{#case \'example-workload\'}}Example Workload{{/case}} ',
'        {{#case \'reference-architecture\'}}Reference Architecture{{/case}}',
'        {{#case \'solution-idea\'}}Solution Idea{{/case}}',
'    {{/switch}}</p>',
'        <a class="card-content-title" href="{{ article.http_url }}">',
'            <h3>{{ article.title }}</h3>',
'        </a>',
'        <ul class="card-content-metadata">',
'            <li>{{ article.publish_date }}</li>',
'            <li>{{ article.read_time }}</li>',
'        </ul>',
'        <p class="card-content-description">{{ article.description }}',
'           <div class="bottom-to-top-fade is-hidden-mobile"></div>',
'        </p>',
'        <p class="hidden-item">{{ article.filter_text }}</p>',
'   </div>',
'   <div class="card-footer">',
'       <div class="card-footer-item left-aligned">',
'           <ul class="tags">',
'               {{#if article.sample_code}}{{#unless article.github_url }}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.http_url }}">Sample Code</a></li>',
'               {{/unless}}{{/if}}',
'               {{#if article.pricing_calculator}}{{#unless article.pricing_guidance}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.pricing_calculator }}">Pricing Calculator</a></li>',
'               {{/unless}}{{/if}}',
'               {{#if article.deployable}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.deployable }}">Deploy to Azure</a></li>',
'               {{/if}}',
'               {{#if article.visio_diagram}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.visio_diagram }}">Visio Diagram</a></li>',
'               {{/if}}',
'               {{#if article.github_url}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.github_url }}"><span class="docon docon-brand-github"></span>&nbsp;Github Project</a></li>',
'               {{/if}}',
'               {{#if article.interactive_diagram}}{{#unless article.visio_diagram }}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.http_url }}">Interactive Diagram</a></li>',
'               {{/unless}}{{/if}}',
'               {{#if article.data_flow}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.http_url }}#{{ article.data_flow }}">Data Flow</a></li>',
'               {{/if}}',
'               {{#if article.components}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.http_url }}#{{ article.components }}">Component details</a></li>',
'               {{/if}}',
'               {{#if article.pricing_guidance}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.http_url }}#{{ article.pricing_guidance }}">Pricing Details</a></li>',
'               {{/if}}',
'               {{#if article.alternative_choices}}',
'               <li class="tag is-small"><a class="black-link" href="{{ article.http_url }}#{{ article.alternative_choices }}">Alternate Configurations</a></li>',
'               {{/if}}',
'           </ul>',
'       </div>',
'    </div>',
'</article>',
'</li>',
'{{/each}}'].join('');
var cardTemplate = Handlebars.compile(cardString);


var pageString = ['<nav class="pagination" role="navigation" aria-label="pagination">',
'    {{#ifCond totalPages \'>\' 1 }}',
'        {{#ifCond currentPage \'>\' 1 }}',
'        <a class="pagination-previous" aria-label="previous" data-page="{{#math currentPage \'-\' 1}}{{/math}}" href="#" onclick="updateUrlBar(getQuery(firstLoad=false, pageNumber={{#math currentPage \'-\' 1}}{{/math}}))">',
'            <span class="icon" aria-hidden="true">',
'                <span class="docon docon-arrow-left"></span>',
'            </span>',
'        </a>',
'        {{/ifCond}}',
'        {{#ifCond currentPage \'<\' totalPages }}',
'        <a class="pagination-next" aria-label="next" data-page="{{#math currentPage \'+\' 1}}{{/math}}" href="#" onclick="updateUrlBar(getQuery(firstLoad=false, pageNumber={{#math currentPage \'+\' 1}}{{/math}}))">',
'            <span class="icon" aria-hidden="true">',
'                <span class="docon docon-arrow-right">',
'                </span>',
'            </span>',
'        </a>',
'        {{/ifCond}}',
'        <ul class="pagination-list">',
'            {{#times totalPages}}',
'                {{#showPage this ../skipStart ../skipEnd ../currentPage}}',
'                    <li>',
'                    <a class="pagination-link{{#ifCond this \'==\' ../currentPage}} is-current{{/ifCond}}" data-page="this" href="#" onclick="updateUrlBar(getQuery(firstLoad=false, pageNumber={{this}}))" aria-label="Page {{this}} of {{../totalPages}}" data-linktype="self-bookmark">{{this}}</a>',
'                    </li>',
'                {{else}}',
'                    {{#elips this ../skipStart ../skipEnd ../currentPage}}',
'                    <li>',
'                        <span class="pagination-ellipsis">&hellip;</span>',
'                    </li>',
'                    {{/elips}}',
'                {{/showPage}}',
'            {{/times}}',
'        </ul>',
'    {{/ifCond}}',
'</nav>'].join('');
var paginationTemplate = Handlebars.compile(pageString);

function findCommonElement(array1, array2) { 
    for(var i = 0; i < array1.length; i++) { 
        for(var j = 0; j < array2.length; j++) { 
            if(array1[i] === array2[j]) { 
                return true; 
            } 
        } 
    } 
    return false;  
} 

function checkCheckboxes(parsedFilters) {
    // Check all checkboxes passed in URL
    parsedFilters.forEach(function(filter){
        $( "input[friendly-name='" + filter + "']" ).prop("checked", true);
        toggle($( "input[friendly-name='" + filter + "']" ).closest("div[data-bi-name]").find(".expander-button"), forceExpand=true);
    });
}

function expandGroups(expandedGroups) {
    // Expand anything that was previously expanded
    expandedGroups.forEach(function(item){
        toggle($(".expander-button[aria-controls='" + item + "']"), forceExpand=true);
    });
}

function setSearchText() {
    var parsedParams = new URLSearchParams(window.location.search);

    if (parsedParams.get("search")) {
        $('#search-content').val(parsedParams.get("search"));
    }
}

function getQuery(firstLoad, pageNumber) {   
    var parsedParams = new URLSearchParams(window.location.search);

    // Create an array of every checkbox
    var selectedNames = getCheckedItems();
    var searchText = getSearchBoxText();

    var parsedFilters = [];
    if (firstLoad) {
        var parsedFilters = parsedParams.getAll("filter");
    }

    if (!pageNumber){
        pageNumber = getPageNumber();
    } 

    var branch;
    if (parsedParams.get("branch")) {
        branch = parsedParams.get("branch");
    } else {
        branch = "";
    }

    var filterNames = Array.from(new Set([...selectedNames, ...parsedFilters]));
    checkCheckboxes(filterNames);

    var queryParams = {
        "filter": filterNames,
        "search": searchText,
        "page": pageNumber,
        "branch": branch
    };

    function isEmpty(value){
        return value === null || value === "";
    }

    for(var key in queryParams) {
        if(isEmpty(queryParams[key])) {
            delete queryParams[key]; 
        }
    }

    if (queryParams.page == 1) {
        delete queryParams.page;
    }

    return queryParams;
}

function updateUrlBar(queryParams) {
    var newUrl = "?" + $.param(queryParams, true);
    window.history.replaceState("object or string", document.title, newUrl);
    filter();
}

function getCheckedItems() {
    var selectedNames = [];
    $('input[type=checkbox]:checked').map(function(){
        selectedNames.push($(this).attr('friendly-name'));
    });

    return selectedNames;
}

function getExpandedGroups() {
    var expandedGroups = [];
    $(".expander-button[aria-expanded='false']").map(function(){
      expandedGroups.push($(this).attr('aria-controls'));
    });

    return expandedGroups;
}

function getPageNumber() {
    var parsedParams = new URLSearchParams(window.location.search);

    // Set the page number if it exists
    var pageNumber = 1;
    if (parsedParams.get("page")) {
        pageNumber = parsedParams.get("page");
    }

    return pageNumber;
}

function getSearchBoxText() {
    // Look for items that include the search text
    var searchText = $('#search-content').get(0).value;
    return searchText;
}

function getCheckedBoxes() {
    return $('input[type=checkbox]:checked');
}

function buildFilterList() {
    // Filter the data
    var filterTerms = [];
    var selectedCategories = [];
    var checked = getCheckedBoxes();
    if (checked.length > 0) {
        $.each(checked, function(){
            selectedCategories.push($(this).closest("div").find('[category]')); 
            var checkId = $(this).attr("friendly-name");
            var checkName = $(this).siblings(".checkbox-text").text();
            $(".facet-tags").append('<span class="tag facet-tag" id="' + checkId + '">' +  checkName +
                '<button type="button" aria-label="Remove "' + checkName +
                '" name="' +  checkName + '" class="delete" onclick="unCheck(\'' + checkId +
                '\')"></button></span>');
            filterTerms = filterTerms.concat($(this).val().toLowerCase().split(" "));
        });
    }

    return filterTerms;
}

function buildFilterHtml(tagData) {
    var picker = refineTemplate(tagData);
    $("#refine-content").html(picker);

    var button=$('.expander-button');
    $('.expander-button').on("click", toggle);
    button.each( function () {
        toggle(this);
    });
}

function buildCards(visibleArticles) {
    // Generate cards for visible results
    var cards = cardTemplate(visibleArticles);
    $(".grid").html(cards);

    // Fix the width if there is only one card
    var columns = $(".grid").css("grid-template-columns").split(" ").length;
    if (visibleArticles.length == 1 || columns == 1) {
        $(".grid-item").css("max-width","350px");
    }
}

function buildPageNumbers(articles, visible_count, maxItems) {
    var maxPages = 10;
    var totalPages = Math.ceil(articles.length / maxItems);
    var skipStart;
    var skipEnd;
    var pageNumber = getPageNumber();
    if (totalPages > maxPages) {
        // Trying to figure out where to put the ellipsis
        // TODO: Stupid math, needs to be better
        skipStart = Math.ceil((totalPages+4-maxPages)/2);
        skipEnd = Math.floor(totalPages-(totalPages-maxPages)+skipStart-2);
    } else {
        skipStart = maxPages+1;
        skipEnd = maxPages+1;
    }

    var pageData = {
        "maxItems": maxItems,
        "visibleArticles": visible_count,
        "totalPages": totalPages,
        "skipStart": skipStart,
        "skipEnd": skipEnd,
        "currentPage": pageNumber
    };
   
    var pagination = paginationTemplate(pageData);
    $(".pagination").remove();
    $("#results").append(pagination);
}

function filter() {
    // Clear any CSS we set before
    $(".grid-item").css("max-width", "");

    // Clear the selected tags
    $(".facet-tag").remove();

    // updateUrlBar(buildQuery());

    // Load content data and filter it        
    var searchText = getSearchBoxText();
    var filterTerms = buildFilterList();

    // Look for items that match the checkbox
    articles = $.grep(window.articleData.articles, function(article) {
        if (filterTerms.length > 0) {
            return findCommonElement(filterTerms, article.tags);
        } else {
            return true;
        }
    });
    
    articles = $.grep(articles, function(article) {
        if (searchText) {
            return article.filter_text.includes(searchText.toLowerCase());
        } else {
            return true;
        }
    });

    // Don't display more than 12 items on a page
    var pageNumber = getPageNumber();
    var maxItems = 12;
    var articleStart = 1 + (pageNumber - 1) * maxItems;
    var articleEnd = articleStart + maxItems - 1;

    // Show all items that should be visible
    var visibleArticles = { "articles": articles.slice(articleStart-1, articleEnd) };
    buildCards(visibleArticles);

    // Get the tags for every checked item
    //var visibleArticleTags = Array.from(new Set([].concat.apply([], data.articles.map(data => data.tags)).sort()));

    // TODO: Fix Filter to not filter current category
    // var selectedCategories = [];
    // filteredTagData = tagData["categories"].filter(function(category) {
    //     var foundItems = category['items'].filter(function(item) {
    //         return item['tags'].some(r=> visibleArticleTags.includes(r));
    //     });
    //     category['items'] = foundItems
    //     return category['items'];
    // });

    // tagData["categories"]=filteredTagData
            
    buildPageNumbers(articles, visibleArticles.articles.length, maxItems);

    $(".resultcount").text(articles.length + " Architectures Found");
}

$(window).resize(function() { 
    $(".grid-item").css("max-width", "");
    filter();
}); 

$(document).ready(function(){
    // Set the background class to match the SearchFilter
    $(".mainContainer").addClass("has-body-background-dark main-full-height is-full has-default-focus");
    $(".mainContainer").removeClass("uhf-container");
    $("#hub-page-main").removeClass();

    $("#search-content-form").submit(function(event){
        event.preventDefault();
      });

    $.getJSON('/azure/architecture/solution-ideas/data/output.json.txt', function (articleData) {
        $.getJSON('/azure/architecture/solution-ideas/metadata/display-tags.json.txt', function (tagData) {
            window.articleData = articleData;
            buildFilterHtml(tagData);
            updateUrlBar(getQuery(firstLoad=true));
        });
    });
    
});