<template>
  <draggable
    v-model="lists"
    class="board dragArea"
    group="lists"
    @end="listMoved"
  >
    <list v-for="list in lists" :key="list.id" :list="list" />

    <div class="list">
      <a v-if="!editing" @click="startEditing">Add a list</a>

      <textarea
        v-if="editing"
        ref="message"
        v-model="message"
        class="form-control mt-2 mb-2"
      ></textarea>
      <button v-if="editing" class="btn btn-secondary" @click="createList">Add</button>

      <a v-if="editing" @click="editing = false">Cancel</a>
    </div>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable';
import list from 'components/list.vue';

export default {
  name: 'App',

  components: {
    draggable,
    list,
  },

  data() {
    return {
      editing: false,
      message: '',
      lists: [...this.$store.state.lists],
    };
  },

  methods: {
    startEditing() {
      this.editing = true;
      this.$nextTick(() => this.$refs.message.focus());
    },

    listMoved(event) {
      var data = new FormData;
      data.append('list[position]', event.newIndex + 1);

      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: 'PATCH',
        data,
        dataType: 'json',
      });
    },

    createList() {
      var data = new FormData;
      data.append('list[name]', this.message);

      Rails.ajax({
        url: '/lists',
        type: 'POST',
        data,
        dataType: 'json',
        success: data => {
          this.message = '';
          this.editing = false;
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
.board {
  white-space: nowrap;
  overflow-x: auto;
}
.list {
  background: #e2e4e6;
  border-radius: 3px;
  display: inline-block;
  width: 270px;
  vertical-align: top;
  margin-right: 20px;
  padding: 10px;
}
</style>
