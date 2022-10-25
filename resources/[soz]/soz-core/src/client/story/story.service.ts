import { Inject, Injectable } from '../../core/decorators/injectable';
import { wait } from '../../core/utils';
import { Dialog } from '../../shared/story/story';
import { AudioService } from '../nui/audio.service';

@Injectable()
export class StoryService {
    @Inject(AudioService)
    private audioService: AudioService;

    private camera: number | null = null;

    public async launchDialog(dialog: Dialog, useCamera = false, x?: number, y?: number, z?: number, w?: number) {
        if (x && y && z && w) {
            TaskGoStraightToCoord(PlayerPedId(), x, y, z, 1.0, 1000, w, 0.0);
            await wait(2000);
            SetEntityHeading(PlayerPedId(), w);
        }
        FreezeEntityPosition(PlayerPedId(), true);

        if (useCamera) {
            await wait(1000);
            this.camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true);

            SetCamCoord(this.camera, x, y, z);
            SetCamActive(this.camera, true);

            const [cx, cy, cz] = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -2.0, 0.5, 0.0);
            SetCamCoord(this.camera, cx, cy, cz);
            SetCamRot(this.camera, 0, 0, w - 90.0, 0);
            RenderScriptCams(true, true, 500, true, true);
        }

        await this.audioService.playAudio(dialog.audio);
        await this.drawTextDialog(dialog.text);

        if (DoesCamExist(this.camera)) {
            RenderScriptCams(false, false, 0, true, false);
            DestroyCam(this.camera, false);
        }

        FreezeEntityPosition(PlayerPedId(), false);
    }

    private async drawTextDialog(text: string[]) {
        for (const line of text) {
            const textDuration = line.length * 5;

            for (let i = 0; i < textDuration; i++) {
                SetTextScale(0.5, 0.5);
                SetTextFont(4);
                SetTextDropshadow(1.0, 0, 0, 0, 255);
                SetTextEdge(1, 0, 0, 0, 255);
                SetTextColour(255, 255, 255, 215);
                SetTextJustification(0);
                SetTextEntry('STRING');
                AddTextComponentString(line);
                DrawText(0.5, 0.95);

                DrawRect(0.25 + 0.5 / 2, 0.94 + 0.05 / 2, 0.5, 0.05, 11, 11, 11, 200);

                await wait(0);
            }
        }
    }
}
