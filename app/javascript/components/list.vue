<template>
  <div class="list">
    <h6>{{ list.name }}</h6>

    <draggable
      v-model="list.cards"
      class="dragArea"
      group="cards"
      @change="cardMoved"
    >
      <card
        v-for="card in list.cards"
        :key="card.id"
        :card="card"
      />
    </draggable>

    <a v-if="!editing" @click="startEditing">Add a card</a>

    <textarea
      v-if="editing"
      ref="message"
      v-model="message"
      class="form-control mb-2"
    ></textarea>
    <button v-if="editing" class="btn btn-secondary" @click="createCard">Add</button>

    <a v-if="editing" @click="editing = false">Cancel</a>
  </div>
</template>

<script>
import draggable from 'vuedraggable';
import card from 'components/card';

export default {
  name: 'List',

  components: {
    draggable,
    card,
  },

  props: ['list'],

  data() {
    return {
      editing: false,
      message: '',
    };
  },

  methods: {
    startEditing() {
      this.editing = true;
      this.$nextTick(() => this.$refs.message.focus());
    },

    cardMoved(event) {
      const evt = event.added || event.moved;

      if (evt == undefined) return;

      const { element } = evt;
      const list_index = this.$store.state.lists.findIndex(list =>
        list.cards.find(card => card.id === element.id),
      );

      var data = new FormData;
      data.append('card[list_id]', this.$store.state.lists[list_index].id);
      data.append('card[position]', evt.newIndex + 1);

      Rails.ajax({
        url: `/cards/${evt.element.id}/move`,
        type: 'PATCH',
        data,
        dataType: 'json',
      });
    },

    createCard() {
      var data = new FormData;
      data.append('card[list_id]', this.list.id);
      data.append('card[name]', this.message);

      Rails.ajax({
        url: '/cards',
        type: 'POST',
        data,
        dataType: 'json',
        success: data => {
          this.message = '';
          this.$nextTick(() => this.$refs.message.focus());
        },
      });
    },
  },
};
</script>

<style scoped>
.dragArea {
  min-height: 10px;
}
</style>
