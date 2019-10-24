import Controller from '@ember/controller';
import slugify, { removeDiacritics } from 'ember-slugify';

import { task } from 'ember-concurrency';

export default Controller.extend({

	isVisible: true,
	errors: null,
	selectedCategory: null,
	newCategory: null,
	validCategory: false,

	actions: {
		toggleVisible() {
			this.toggleProperty('isVisible');
		},
		index() {
			this.transitionToRoute('movies');
		},
		clearNew() {
			this.set('newCategory', null);
		},
		clearCatList() {
			this.get('categoriesMenu').clear();
		},
		async create() {
			this.set('errors', null);
			let model = this.get('model');
			let category = this.get('selectedCategory');
			let newCategory = this.get('newCategory');
			let missingCategory = (!category && !newCategory);

			await this._validateCategory.perform();

			let categoryToUse = category ? category : newCategory;

			if (category) this.set('validCategory', true);

			if (model.validate() && !missingCategory && this.get('validCategory')) {

				let [categoryTitle, subCategoryTitle] = categoryToUse.split('|');
				let slug = slugify(removeDiacritics(categoryTitle));
				let subCategorySlug = slugify(removeDiacritics(subCategoryTitle));
				let movieCategory;

				let newMovie = this.store.createRecord('movie', {
					title: model.title,
					description: model.description,
					image_url: model.image_url || 'https://picsum.photos/id/338/1920/300',
					visible: this.isVisible
				});

				if (category) {
					await this.store.query('category', {
						filter: {
							slug: slug,
							sub_category_slug: subCategorySlug
						}
					}).then(async movieCategory => {
						newMovie.set('category', movieCategory.get('firstObject'));
						await newMovie.save();
					});
				} else {
					movieCategory = this.store.createRecord('category', {
						title: categoryTitle,
						slug: slug,
						sub_category_title: subCategoryTitle,
						sub_category_slug: subCategorySlug,
						image_url: 'https://picsum.photos/id/250/1920/300'
					});

					let savedCategory = await movieCategory.save();
					newMovie.set('category', savedCategory);
					await newMovie.save();
				}

				this.transitionToRoute(`/genres/${slug}/${subCategorySlug}`);

			} else {
				let errorsMap = model.get('errors').errorsByAttributeName;
				let errors = Object.fromEntries(errorsMap);

				Object.keys(errors).map(function(field, index) {
				  errors[field] = (errors[field][0].message)[0];
				});

				if (missingCategory) {
					errors['existing_category'] = 'category is required. Select a category ...';
					errors['new_category'] = 'or create a new one.';
				}

				this.set('errors', errors);
			}
		}
	},

	_validateCategory: task(function * () {

		let newCategory = this.get('newCategory');

		if (!newCategory) {
			this.set('validCategory', false);
			return;
		}

		let [category, subCategory] = newCategory.split('|');

		category = slugify(removeDiacritics(category));
		subCategory = slugify(removeDiacritics(subCategory));
 
		let searchResults = this.store.loadRecords('category', {
			filter: {
				slug: category,
				sub_category_slug: subCategory
			}
		}).then(records => records);

		let similarCategories = [];

		try {
			similarCategories = yield searchResults
		} catch(e) {
			console.error('Failed to check for category presence.');
		}
		
		this.set('validCategory', similarCategories.length == 0);
	})

});
