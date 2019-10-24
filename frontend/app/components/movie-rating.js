import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
	session: service('session'),
	ajax: service('ajax'),
	initialMovieRating: null,
	rating: null,
	actions: {
		async updateRating(rating) {
			this.set('rating', rating);

			let movie = this.movie	
			let currUserRating = movie.current_user_rating;

			if (currUserRating && currUserRating.id) {
				this.get('ajax').request(`/ratings/${currUserRating.id}`, {
					method: 'PATCH',
					data: {rating: {score: rating}}
				});
			} else {
				await this.get('ajax').request(`/ratings/`, {
					method: 'POST',
					data: {rating: {score: rating, movie_id: movie.id}}
				}).then(ratingObj => {
					movie.set('current_user_rating', ratingObj);
				});
			}

			movie.set('current_user_rating.score', rating);
		}
	}
});