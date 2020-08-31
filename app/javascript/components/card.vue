<template>
  <div>
    <div class="card card-body mb-3" @click="editing = true">
      {{ card.name }}
    </div>

    <div v-if="editing" class="modal-backdrop show"></div>

    <div
      v-if="editing"
      class="modal show"
      style="display: block;"
      @click="closeModal"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ card.name }}</h5>
          </div>

          <div class="modal-body">
            <input v-model="name" class="form-control" />
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-primary" @click="save">
              Save changes
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Card',

  props: ['card'],

  data() {
    return {
      editing: false,
      name: this.card.name,
    };
  },

  methods: {
    closeModal(event) {
      if (event.target.classList.contains('modal')) {
        this.editing = false;
      }
    },

    save() {
      var data = new FormData;
      data.append('card[name]', this.name);

      Rails.ajax({
        url: `/cards/${this.card.id}`,
        type: 'PATCH',
        data,
        dataType: 'json',
        success: data => {
          this.editing = false;
        },
      });
    },
  },
};
</script>
