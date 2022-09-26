import { OnNuiEvent } from '../../core/decorators/event';
import { Inject } from '../../core/decorators/injectable';
import { Provider } from '../../core/decorators/provider';
import { emitRpc } from '../../core/rpc';
import { NuiEvent } from '../../shared/event';
import { RpcEvent } from '../../shared/rpc';
import { DrawService } from '../draw.service';
import { Qbcore } from '../qbcore';

@Provider()
export class AdminMenuInteractiveProvider {
    @Inject(DrawService)
    private drawService: DrawService;

    @Inject(Qbcore)
    private QBCore: Qbcore;

    private intervalHandlers = {
        displayOwners: null,
        displayPlayerNames: null,
        displayPlayersOnMap: null,
    };

    private multiplayerTags: Map<string, number> = new Map();
    private playerBlips: Map<string, number> = new Map();

    @OnNuiEvent(NuiEvent.AdminToggleDisplayOwners)
    public async toggleDisplayOwners(): Promise<void> {
        if (this.intervalHandlers.displayOwners) {
            clearInterval(this.intervalHandlers.displayOwners);
            return;
        }
        this.intervalHandlers.displayOwners = setInterval(async () => {
            const vehicles: number[] = GetGamePool('CVehicle');
            for (const vehicle of vehicles) {
                const vehicleCoords = GetEntityCoords(vehicle, false);
                const playerCoords = GetEntityCoords(PlayerPedId(), false);
                const dist = GetDistanceBetweenCoords(
                    vehicleCoords[0],
                    vehicleCoords[1],
                    vehicleCoords[2],
                    playerCoords[0],
                    playerCoords[1],
                    playerCoords[2],
                    false
                );
                if (dist < 50) {
                    let text = ' | OwnerNet: ';
                    if (GetPlayerServerId(NetworkGetEntityOwner(vehicle)) == GetPlayerServerId(PlayerId())) {
                        text = ' | ~g~OwnerNet: ';
                    }
                    const ownerInfo =
                        `${GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))} ` +
                        `| VehicleNet: ${NetworkGetNetworkIdFromEntity(vehicle)} ` +
                        `${text} ${GetPlayerServerId(NetworkGetEntityOwner(vehicle))}`;
                    const vehicleInfo =
                        `Vehicle Engine Health: ${GetVehicleEngineHealth(vehicle)} ` +
                        `| Vehicle Body Health: ${GetVehicleBodyHealth(vehicle)}` +
                        `| Vehicle Oil: ${GetVehicleOilLevel(vehicle)}/${GetVehicleHandlingFloat(
                            vehicle,
                            'CHandlingData',
                            'fOilVolume'
                        )}`;
                    this.drawService.drawText3d(vehicleCoords[0], vehicleCoords[1], vehicleCoords[2] + 1, ownerInfo);
                    this.drawService.drawText3d(vehicleCoords[0], vehicleCoords[1], vehicleCoords[2] + 2, vehicleInfo);
                }
            }
        }, 1);
    }

    @OnNuiEvent(NuiEvent.AdminToggleDisplayPlayerNames)
    public async toggleDisplayPlayerNames(): Promise<void> {
        if (this.intervalHandlers.displayPlayerNames) {
            clearInterval(this.intervalHandlers.displayPlayerNames);
            return;
        }
        this.intervalHandlers.displayPlayerNames = setInterval(async () => {
            for (const value of Object.values(this.multiplayerTags)) {
                RemoveMpGamerTag(value);
            }

            // TODO: Use proper type
            const players = await emitRpc<any[]>(RpcEvent.ADMIN_GET_PLAYERS);

            players.forEach(player => {
                this.multiplayerTags[player.citizenid] = GetPlayerFromServerId(player.sourceplayer);
                CreateMpGamerTagWithCrewColor(
                    this.multiplayerTags[player.citizenid],
                    player.name,
                    false,
                    false,
                    '',
                    0,
                    0,
                    0,
                    0
                );
                SetMpGamerTagVisibility(this.multiplayerTags[player.citizenid], 0, true);
            });
        }, 5000);
    }

    @OnNuiEvent(NuiEvent.AdminToggleDisplayPlayersOnMap)
    public async toggleDisplayPlayersOnMap(): Promise<void> {
        if (this.intervalHandlers.displayPlayersOnMap) {
            clearInterval(this.intervalHandlers.displayPlayersOnMap);
            return;
        }
        this.intervalHandlers.displayPlayersOnMap = setInterval(async () => {
            for (const value of Object.values(this.playerBlips)) {
                this.QBCore.removeBlip(value);
            }

            const players = await emitRpc<any[]>(RpcEvent.ADMIN_GET_PLAYERS);
            for (const player of players) {
                const blipId = 'admin:player-blip:' + player.citizenid;
                this.playerBlips[player.citizenid] = blipId;

                this.QBCore.createBlip(blipId, {
                    coords: player.coords,
                    heading: player.heading,
                    name: player.name,
                    showheading: true,
                    sprite: 1,
                });
            }
        }, 2500);
    }
}
