# frozen_string_literal: true

Rails.logger.debug 'Seeding Posts'

BLURB = <<-TXT
  Sagittis scelerisque nulla cursus
  in enim consectetur quam. Dictum urna sed consectetur neque tristique
  pellentesque. Blandit amet, sed aenean erat arcu morbi.
TXT
BODY = <<-TXT
  <p>Sollicitudin tristique eros erat odio sed vitae, consequat turpis
    elementum. Lorem nibh vel, eget pretium arcu vitae. Eros eu viverra
    donec ut volutpat donec laoreet quam urna.</p>
  <p>Bibendum eu nulla feugiat justo, elit adipiscing. Ut tristique sit
    nisi lorem pulvinar. Urna, laoreet fusce nibh leo. Dictum et et et
    sit. Faucibus sed non gravida lectus dignissim imperdiet a.</p>
  <p>Dictum magnis risus phasellus vitae quam morbi. Quis lorem lorem
    arcu, metus, egestas netus cursus. In.</p>

  <ul role="list">
    <li>Quis elit egestas venenatis mattis dignissim.</li>
    <li>Cras cras lobortis vitae vivamus ultricies facilisis tempus.
    </li>
    <li>Orci in sit morbi dignissim metus diam arcu pretium.</li>
  </ul>

  <p>Rhoncus nisl, libero egestas diam fermentum dui. At quis tincidunt
    vel ultricies. Vulputate aliquet velit faucibus semper. Pellentesque
    in venenatis vestibulum consectetur nibh id. In id ut tempus
    egestas. Enim sit aliquam nec, a. Morbi enim fermentum lacus in.
    Viverra.</p>

    <h3 class="text-color">
    How we're different
  </h3>

  <p>Tincidunt integer commodo, cursus etiam aliquam neque, et.
    Consectetur pretium in volutpat, diam. Montes, magna cursus nulla
    feugiat dignissim id lobortis amet. Laoreet sem est phasellus eu
    proin massa, lectus. Diam rutrum posuere donec ultricies non morbi.
    Mi a platea auctor mi.</p>
  <p>Mauris ullamcorper imperdiet nec egestas mi quis quam ante
    vulputate. Vel faucibus adipiscing lacus, eget. Nunc fermentum id
    tellus donec. Ut metus odio sit sit varius non nunc orci. Eu, mi
    neque, ornare suspendisse amet, nibh. Facilisi volutpat lectus id
    sapien dis mauris rhoncus. Est rhoncus, interdum imperdiet ac eros,
    diam mauris, tortor. Risus id sit molestie magna.</p>
TXT

def update_post(post, cta:, image_url:, blurb: BLURB, body: BODY)
  post.update!(cta: cta, image_url: image_url, blurb: blurb, body: body)
end

post1 = Post.where(title: 'Work With Us').first_or_create!
cta = 'Our Process 👋'
image_url = "https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80"
update_post(post1, cta: cta, image_url: image_url)

post2 = Post.where(title: 'Explore Deeper').first_or_create!
cta = 'Take a Breathe 😮‍💨'
image_url = "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80"
update_post(post2, cta: cta, image_url: image_url)

post3 = Post.where(title: 'Get Your Feet Wet').first_or_create!
cta = 'Enjoy the view 🌅'
image_url = "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80"
update_post(post3, cta: cta, image_url: image_url)
