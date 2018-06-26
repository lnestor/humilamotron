seinfeld = User.create(name: 'Jerry Seinfeld', groupme_id: 1)
elaine = User.create(name: 'Elaine Benes', groupme_id: 2)
kramer  = User.create(name: 'Kramer', groupme_id: 3)
george = User.create(name: 'George Costanza', groupme_id: 4)

group1 = Group.create(name: 'Seinfeld Cast', groupme_id: 12345)
group2 = Group.create(name: 'A Show About Nothing', groupme_id: 12346)

LikedMessage.create(user: george, content: "I have a bad feeling that whenever a lesbian looks at me they thing 'That's why I'm not a heterosexual.'", groupme_id: 1, group: group1)
LikedMessage.create(user: george, content: "When you look annoyed all the time, people think that you're busy.", groupme_id: 2, group: group2)

LikedMessage.create(user: elaine, content: "It seems that a psychotic mechanic has absconded with my friend's car.", groupme_id: 3, group: group2, image_url: "https://article.images.consumerreports.org/prod/content/dam/CRO%20Images%202017/Magazine-Articles/April/CR-Inline-top-picks-Toyota-Yaris-02-17")
LikedMessage.create(user: elaine, content: "It's the best part. It's crunchy, it's explosive, it's where the muffin breaks free of the pan and sort of does its own thing. I'll tell you. That's a million-dollar idea right there. Just sell the tops.", groupme_id: 4, group: group1)
LikedMessage.create(user: elaine, content: "We don’t know how long this will last. They are a very festive people.", groupme_id: 5, group: group1)

LikedMessage.create(user: kramer, content: "You ever dream in 3-D? It’s like the bogeyman is coming RIGHT AT YOU.", groupme_id: 6, group: group1)
LikedMessage.create(user: kramer, content: "Well, you’re just as pretty as any of them. You just need a nose job.", groupme_id: 7, group: group2, image_url: "https://cdn.shopify.com/s/files/1/0788/5229/products/kramer2.jpg?v=1464313073")

LikedMessage.create(user: seinfeld, content: "You can't believe this woman. She's one of those low-talkers. You can't hear a word she's saying! You're always going 'excuse me?', 'what was that?'", groupme_id: 8, group: group2)

Admin.create(email: 'test@example.com', password: '123456', password_confirmation: '123456')
