import { shallowMount } from '@vue/test-utils'
import MyComponent from '@/components/MyComponent.vue'

describe('MyComponent', () => {
  it('renders props.msg when passed', () => {
    const msg = 'new message'
    const wrapper = shallowMount(MyComponent, {
      props: { msg },
    })
    expect(wrapper.text()).toContain(msg)
  })
})
