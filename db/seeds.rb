# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(name: 'Lucas Nestor', groupme_id: 12345)
user2 = User.create(name: 'Brett Ringel', groupme_id: 12346)

LikedMessage.create(user: user1, content: 'You suck a Fortnite', groupme_id: 123, group_groupme_id: 1)
LikedMessage.create(user: user1, content: 'and also TF2', groupme_id: 124, group_groupme_id: 1)
LikedMessage.create(user: user2, content: 'I know, you are right.', groupme_id: 125, group_groupme_id: 1)
