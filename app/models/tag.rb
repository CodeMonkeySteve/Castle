class Tag < CouchRest::Model::Base
  belongs_to :user
  belongs_to :target, class_name: 'Track'

  property :tags, default: {}

  design do
    view :by_user_id_and_target_id
    view :by_tag_and_target,
      map: "function(doc) {
        if (doc['type'] == 'Tag' && doc.tags) {
          for (var tag in doc.tags) {
            emit([tag, doc.target_id], { count: 1, sum: doc.tags[tag] })
          }
        }
      }",
      reduce: "function(keys, values, rereduce) {
        var sum = 0, count = 0;
        for (var i in values) {
          sum += values[i].sum
          count += values[i].count
        }
        return sum / count;
      }"
  end
end