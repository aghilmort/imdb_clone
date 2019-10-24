import DS from 'ember-data';
const { Model, attr } = DS;

export default Model.extend({
	title: attr(),
	slug: attr(),
	sub_category_title: attr(),
	sub_category_slug: attr(),
	description: attr(),
	image_url: attr(),
	movies: DS.hasMany('movies')
});
