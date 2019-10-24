import RouteMixin from 'ember-cli-pagination/remote/route-mixin'
import Route from '@ember/routing/route';

export default Route.extend(RouteMixin, {
	queryParams: {
		page: {
			refreshModel: true
		}
	},
	model(params) {
		return this.store.query('movie', {
			filter: { slug: params.slug }
		})
	}
});