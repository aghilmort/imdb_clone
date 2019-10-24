import Controller from '@ember/controller';
import { computed } from '@ember/object';
import groupBy from 'ember-group-by';

export default Controller.extend({
	actions: {
		new() {
			this.transitionToRoute('movies.new');
		},
		editMovie(id) {
			this.transitionToRoute(`/movies/${id}/edit`);
		}
	},
	raw_categories: computed('model', function () {
		return this.store.findAll('category');
	}),
	categoriesBySlug: groupBy('raw_categories', 'slug'),
});
