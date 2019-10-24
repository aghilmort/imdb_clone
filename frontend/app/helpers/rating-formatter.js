import { helper } from '@ember/component/helper';

export default helper(function ratingFormatter([rating]) {
	if (isNaN(rating) || rating === null) {
		return '(not rated)';
	}

	let toOneDecimal = Math.round(rating * 10) / 10;

	rating = Number.isInteger(toOneDecimal) ? Math.round(rating) : toOneDecimal;

  return `${rating}/10`;
});
