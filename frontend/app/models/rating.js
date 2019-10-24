import DS from 'ember-data';
const { Model, attr, belongsTo } = DS;

export default Model.extend({
  score: attr(),
  description: attr(),
  movieId: belongsTo('movie'),
  userId: belongsTo('user')
});
