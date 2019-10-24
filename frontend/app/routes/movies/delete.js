import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import Route from '@ember/routing/route';

export default Route.extend(AuthenticatedRouteMixin, {
	model: function (params) {
		return this.store.findRecord('movie', params.movie_id, { reload: true })
			.then(movie => {
				movie.destroyRecord();
			});
	},
	afterModel() {
		this.transitionTo('movies');
	}
});