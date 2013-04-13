atom_feed :language => 'en-US' do |feed|
  feed.title @feed_title
  feed.updated @updated

  @feed_items.each do |item|
    next if item.created_at.blank?

    feed.entry(item) do |entry|
      entry.url view_profile_url(item.username)
      entry.title "#{item.name} - #{User::CATEGORIES[item.category]}"
      entry.content "#{content_tag("p", image_tag(item.image.file.square))} #{content_tag("p", item.bio)}", :type => "html"

      # Google Reader needs the strftime, so it might not be necessary much longer :)
      entry.updated(item.created_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name @site_title
      end
    end
  end
end