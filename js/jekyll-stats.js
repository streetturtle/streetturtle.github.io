---
---

var accentColor = "#3CA2A2";

var datePostsWords = [
    {% for post in site.posts %}
        {
            "t":"{{post.date | date: '%Y-%-m'}}",
            "year":"{{post.date | date: '%Y'}}",
            "x":1,
            "y":{{ post.content | number_of_words }}
        },
    {% endfor %}
];

var firstYear = parseInt("{{ site.posts.last.date | date: '%Y'}}"),
    lastYear = parseInt("{{ site.posts.first.date | date: '%Y'}}");

var datePostsWordsZeros = [];
for (var i = firstYear; i <= lastYear; i++) {
    for (var j = 1; j < 13; j++) {
        datePostsWordsZeros.push({"t": '' + i + "-" + j, "x": 0, "y": 0});
    }
}

var datePostsWords = datePostsWordsZeros.concat(datePostsWords);

var postsPerMonth = datePostsWords.reduce((p, c) => {
    var name = c.t;
    if (!p.hasOwnProperty(name)) {
        p[name] = 0;
    }
    p[name] = p[name] + c.x;
    return p;
}, {});

var postsPerYear = datePostsWords.reduce((p, c) => {
    if (c.year === undefined)
        return p;
    var name = c.year;
    if (!p.hasOwnProperty(name)) {
        p[name] = 0;
    }
    p[name] = p[name] + c.x;
    return p;
}, {});

var wordsPerMonth = datePostsWords.reduce((p, c) => {
    var name = c.t;
    if (!p.hasOwnProperty(name)) {
        p[name] = 0;
    }
    p[name] = p[name] + c.y;
    return p;
}, {});


var postsPerMonthCtx = document.getElementById("postsPerMonth").getContext('2d');
var postsPerMonthChart = new Chart(postsPerMonthCtx, {
    type: 'bar',
    data: {
        labels: Object.keys(postsPerMonth),
        datasets: [{
            label: 'Post(s)',
            data: Object.values(postsPerMonth),
            backgroundColor: accentColor,
            borderWidth: 1
        }],
    },
    options: {
        scales: {
            xAxes: [{
                categoryPercentage: 1.0,
                barPercentage: 1.0
            }]
        }
    }
});

var wordsPerMonthCtx = document.getElementById("wordsPerMonth").getContext('2d');
var wordsPerMonthChart = new Chart(wordsPerMonthCtx, {
    type: 'bar',
    data: {
        labels: Object.keys(wordsPerMonth),
        datasets: [{
            label: 'Number of words',
            data: Object.values(wordsPerMonth),
            backgroundColor: accentColor,
            borderWidth: 1
        }],
    },
    options: {
        scales: {
            xAxes: [{
                categoryPercentage: 1.0,
                barPercentage: 1.0
            }]
        }
    }
});


var postsPerYearCtx = document.getElementById("postsPerYear").getContext('2d');
var postsPerYearChart = new Chart(postsPerYearCtx, {
    type: 'bar',
    data: {
        labels: Object.keys(postsPerYear),
        datasets: [{
            label: 'Number of posts',
            data: Object.values(postsPerYear),
            backgroundColor: accentColor,
            borderWidth: 1
        }],
    },
    options: {
        scales: {
            xAxes: [{
                categoryPercentage: 1.0,
                barPercentage: 1.0
            }]
        }
    }
});


function drawTagsDistributionChart(){
    // sort tags by number of posts
    {% capture tags %}
    {% for tag in site.tags %}
    {{ tag[1].size | plus: 1000 }}#{{ tag[0] }}#{{ tag[1].size }}/
    {% endfor %}
    {% endcapture %}
    {% assign sortedtags = tags | split:'/' | sort %}

    // get tags names
    var pieLabels = [
        {% for tag in sortedtags reversed %}
            {% assign tagitems = tag | split: '#' %}
            {% for tag in tags %} "{{ tagitems[1] }}", {% endfor %}
        {% endfor %}
    ];

    // get number of posts
    var pieData = [
        {% for tag in sortedtags reversed %}
    {% assign tagitems = tag | split: '#' %}
    {% for tag in tags %} {{ tagitems[2]}}, {% endfor %}
    {% endfor %}
    ];

    var tagsDistrCtx = document.getElementById("tagsDistr").getContext('2d');
    var tagsDistrChart = new Chart(tagsDistrCtx,{
        type: 'pie',
        data: {
            labels: pieLabels,
            datasets: [{
                label: "tag",
                data: pieData,
                borderColor: "#aaa",
                backgroundColor: randomColor({
                    count: pieData.length,
                    hue: accentColor,
                    luminosity: 'dark',
                })
            }],
        },
        options: {
            responsive: true,
        }
    });
}


var totalWords = [ {% for post in site.posts %} {{ post.content | number_of_words }}, {% endfor %} ].reduce((a, b) => a + b, 0);
var totalPosts = {{ site.posts.size }};

function concatBoldTextToELement(id, text) {
    var boldEl = document.createElement('b');
    boldEl.innerText = ' ' + text;
    document.getElementById(id).appendChild(boldEl);
}

concatBoldTextToELement('total-words', totalWords);
concatBoldTextToELement('total-posts', totalPosts);
concatBoldTextToELement('words-per-post', totalWords / totalPosts);

drawTagsDistributionChart();