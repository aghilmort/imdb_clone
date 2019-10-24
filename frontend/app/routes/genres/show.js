import Route from '@ember/routing/route';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin'

export default Route.extend(RouteMixin, {
	queryParams: {
		page: {
			refreshModel: true
		}
	},
	model(params) {
		return this.store.query('movie', {
			filter: {
				slug: params.slug,
				sub_category_slug: params.sub_category_slug
			}
		})
	}
});
