# initialize nokogiri
nokogiri = Nokogiri.HTML(content)

# get the group of listings
listings = nokogiri.css('ul.b-list__items_nofooter li.s-item')

# loop through the listings
listings.each do |listing|
    # initialize an empty hash
    product = {}
    
    # extract the information into the product hash
    product['title'] = listing.at_css('h3.s-item__title')&.text
    
    # extract the price
    product['price'] = listing.at_css('.s-item__price')&.text
    
    # extract the listing URL
    item_link = listing.at_css('a.s-item__link')
    product['url'] = item_link['href'] unless item_link.nil?

    item_img = listing.at_css('img.s-item__image-img')
    product['img_src'] = item_img['src'] unless item_img.nil?

    # specify the collection where this record will be stored
    product['_collection'] = "listings"

    # save the product to the outputs.
    outputs << product

    # enqueue more pages to the scrape job
    pages << {
        url: product['url'],
        page_type: 'details',
        vars: {  # adding vars to this page
            title: product['title'],
            price: product['price'],
            img_src: product['img_src']
        }
    }
    # puts pages
end