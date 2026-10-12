require 'rake'
require 'json'
require 'net/http'
require 'yaml'

desc 'Preview the site with Jekyll'
task :preview do
    sh "jekyll serve --watch --drafts --baseurl '' "
end

desc 'Search site and print specific deprecation warnings'
task :check do
    sh "jekyll doctor"
end

namespace :cv do
    desc 'Build cv.pdf from _data/cv.yml with Typst'
    task :pdf do
        stats_file = 'cv/.github-stats.json'
        repos = YAML.load_file('_data/cv.yml')['sideProjects'].map { |p| p['link'] }
        stats = repos.map do |repo|
            res = Net::HTTP.get_response(URI("https://api.github.com/repos/#{repo}"))
            next warn("GitHub stats skipped for #{repo}: HTTP #{res.code}") unless res.is_a?(Net::HTTPSuccess)
            data = JSON.parse(res.body)
            [repo, { stars: data['stargazers_count'], forks: data['forks'] }]
        end.compact
        File.write(stats_file, JSON.generate(stats.to_h))
        sh "typst compile --root . --font-path cv/fonts --ignore-system-fonts --input github-stats=#{stats_file} cv/cv.typ cv.pdf"
        pages = File.binread('cv.pdf').scan(%r{/Type\s*/Page[^s]}).size
        abort "cv.pdf has #{pages} pages, expected 2" unless pages == 2
        puts 'cv.pdf: 2 pages'
    ensure
        File.delete(stats_file) if stats_file && File.exist?(stats_file)
    end
end
