import DS from 'ember-data';
import Validator from 'ember-model-validator/mixins/model-validator';

const { Model, attr } = DS;

export default Model.extend(Validator, {
	title: attr('string'),
	category: DS.belongsTo('category'),
	description: attr('string'),
	image_url: attr('string'),
	ratings: attr(),
	current_user_rating: attr(),
	average_rating: attr('number'),
	visible: attr('boolean'),

	validations: {
		title: {
			presence: true
		},
		image_url: {
			URL: { allowBlank: true }
		},
		category: {
			relations: ['belongsTo']
		},
		description: {
			length: {
				maximum: {
					value: 1024,
					message: 'description must not exceed 1024 characters.'
				}
			}
		}
	}
});
