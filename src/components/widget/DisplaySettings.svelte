<script lang="ts">
import I18nKey from "@i18n/i18nKey";
import { i18n } from "@i18n/translation";
import Icon from "@iconify/svelte";
import { getDefaultHue, getHue, setHue } from "@utils/setting-utils";

let hue = getHue();
const defaultHue = getDefaultHue();

function resetHue() {
	hue = getDefaultHue();
}

$: if (hue || hue === 0) {
	setHue(hue);
}
</script>

<div id="display-setting" class="float-panel float-panel-closed absolute transition-all w-80 right-4 px-4 py-4">
    <div class="flex flex-row gap-2 mb-3 items-center justify-between">
        <div class="flex gap-2 font-bold text-lg text-neutral-900 dark:text-neutral-100 transition relative ml-3
            before:w-1 before:h-4 before:rounded-md before:bg-[var(--primary)]
            before:absolute before:-left-3 before:top-[0.33rem]"
        >
            {i18n(I18nKey.themeColor)}
            <button aria-label="Reset to Default" class="btn-regular w-7 h-7 rounded-md  active:scale-90 will-change-transform"
                    class:opacity-0={hue === defaultHue} class:pointer-events-none={hue === defaultHue} on:click={resetHue}>
                <div class="text-[var(--btn-content)]">
                    <Icon icon="fa6-solid:arrow-rotate-left" class="text-[0.875rem]"></Icon>
                </div>
            </button>
        </div>
        <div class="flex gap-1">
            <div id="hueValue" class="transition w-11 h-8 rounded-lg flex justify-center
            font-bold text-sm items-center text-[var(--btn-content)]">
                {hue}
            </div>
        </div>
    </div>
    <div class="hue-track-shell w-full h-8 px-2 rounded-xl select-none">
        <input aria-label={i18n(I18nKey.themeColor)} type="range" min="0" max="360" bind:value={hue}
               class="slider" id="colorSlider" step="5" style="width: 100%">
    </div>
</div>


<style lang="stylus">
    #hueValue
      border 1px solid var(--neu-border)
      background var(--surface-low)
      box-shadow inset 3px 3px 7px var(--neu-inset-shadow), inset -3px -3px 7px var(--neu-inset-highlight)

    .hue-track-shell
      display flex
      align-items center
      border 1px solid var(--neu-border)
      background var(--surface-low)
      box-shadow inset 4px 4px 8px var(--neu-inset-shadow), inset -4px -4px 8px var(--neu-inset-highlight)

    #display-setting
      input[type="range"]
        -webkit-appearance none
        height .55rem
        border-radius 999px
        background-image var(--color-selection-bar)
        transition background-image 0.15s ease-in-out

        /* Input Thumb */
        &::-webkit-slider-thumb
          -webkit-appearance none
          height 1.25rem
          width 1.25rem
          border-radius 50%
          border 2px solid rgba(255, 255, 255, .82)
          background var(--card-bg)
          box-shadow 4px 4px 8px var(--neu-shadow), -3px -3px 7px var(--neu-highlight)
          &:hover
            transform scale(1.08)
          &:active
            box-shadow inset 2px 2px 4px var(--neu-inset-shadow), inset -2px -2px 4px var(--neu-inset-highlight)

        &::-moz-range-thumb
          -webkit-appearance none
          height 1.25rem
          width 1.25rem
          border-radius 50%
          border 2px solid rgba(255, 255, 255, .82)
          background var(--card-bg)
          box-shadow 4px 4px 8px var(--neu-shadow), -3px -3px 7px var(--neu-highlight)
          &:hover
            transform scale(1.08)
          &:active
            box-shadow inset 2px 2px 4px var(--neu-inset-shadow), inset -2px -2px 4px var(--neu-inset-highlight)

        &::-ms-thumb
          -webkit-appearance none
          height 1.25rem
          width 1.25rem
          border-radius 50%
          background var(--card-bg)
          box-shadow 4px 4px 8px var(--neu-shadow), -3px -3px 7px var(--neu-highlight)
          &:hover
            transform scale(1.08)
          &:active
            box-shadow inset 2px 2px 4px var(--neu-inset-shadow), inset -2px -2px 4px var(--neu-inset-highlight)

</style>
