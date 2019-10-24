import Controller from '@ember/controller';
import { computed } from '@ember/object';
import slugify, { removeDiacritics } from 'ember-slugify';
import { task } from 'ember-concurrency';

export default Controller.extend({

	errors: null,
	selectedCategory: computed('model', async function() {
		let movie = this.get('model');
		let category = await movie.get('category');
		let slug = category.slug;
		let subCategorySlug = category.sub_category_slug;
		let selected = slug;

		if (subCategorySlug) {
			selected += `|${subCategorySlug}`;
		}

		return selected;
	}),
	newCategory: null,
	validCategory: false,

	actions: {
		toggleVisible() {
			this.set('model.visible', !this.get('model.visible'));
		},
		index() {
			this.transitionToRoute('movies.index');
		},
		clearNew() {
			this.set('newCategory', null);
		},
		clearCatList() {
			this.get('categoriesMenu').clear();
		},
		async update() {

			this.set('errors', null);
			let model = this.get('model');
			let category = await this.get('selectedCategory');
			let newCategory = this.get('newCategory');
			let missingCategory = (!category && !newCategory);

			await this._validateCategory.perform();

			let categoryToUse = category ? category : newCategory;

			if (category) this.set('validCategory', true);

			model.set('category', null);

			if (model.validate() && !missingCategory && this.get('validCategory')) {

				let [categoryTitle, subCategoryTitle] = categoryToUse.split('|');
				let slug = slugify(removeDiacritics(categoryTitle));
				let subCategorySlug = slugify(removeDiacritics(subCategoryTitle));
				let movieCategory;

				if (!model.image_url)	{
					model.set('image_url', 'https://picsum.photos/id/338/1920/300');
				}

				if (category) {
					await this.store.query('category', {
						filter: {
							slug: slug,
							sub_category_slug: subCategorySlug
						}
					}).then(async movieCategory => {
						model.set('category', movieCategory.get('firstObject'));
						await model.save();
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
					model.set('category', savedCategory);
					await model.save();
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
		},
    openModal: function(name) {
      $('.ui.' + name + '.modal').modal('show');
    },

    approveModal: function(element, component) {
      this.transitionToRoute(`/movies/${this.get('model').id}/delete`);
    },

    denyModal: function(element, component) {
      return true;
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
