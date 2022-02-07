import React from 'react';
import {DialerApp} from '../../../apps/dialer/components/DialerApp';
import {ContactsApp} from '../../../apps/contacts/components/ContactsApp';
import {SettingsApp} from '../../../apps/settings/components/SettingsApp';
import {MessagesApp} from '../../../apps/messages/components/MessagesApp';
import {ExampleAppWrapper} from '../../../apps/example/components/ExampleAppWrapper';
import {NotesApp} from '../../../apps/notes/NotesApp';
import CameraApp from '../../../apps/camera/components/CameraApp';
import {SocietyContactsApp} from "../../../apps/society-contacts/components/SocietyContactsApp";
import {AppRoute} from '../components/AppRoute';

import {
    MESSAGES_APP_TEXT_COLOR,
} from '../../../apps/messages/messages.theme';
import {
    CONTACTS_APP_TEXT_COLOR,
} from '../../../apps/contacts/contacts.theme';
import {NOTES_APP_ICON_COLOR} from '../../../apps/notes/notes.theme';
import {DIALER_APP_TEXT_COLOR} from '../../../apps/dialer/dialer.theme';
import {INotificationIcon} from '@os/notifications/providers/NotificationsProvider';
import {
    SOCIETY_CONTACTS_APP_TEXT_COLOR
} from "../../../apps/society-contacts/contacts.theme";
import {BankApp} from "../../../apps/bank/components/BankApp";
import {
    SOCIETY_MESSAGES_APP_TEXT_COLOR
} from "../../../apps/society-messages/messages.theme";
import {SocietyMessagesApp} from "../../../apps/society-messages/components/SocietyMessagesApp";
import PhotoApp from "../../../apps/photo/components/PhotoApp";

export interface IAppConfig {
    id: string;
    nameLocale: string;
    color: string;
    path: string;
    home?: boolean;
    Route: React.FC;
}

export type IApp = IAppConfig & {
    notification: INotificationIcon;
    icon: JSX.Element;
    notificationIcon: JSX.Element;
    NotificationIcon: React.FC<any>;
    Icon?: React.FC<any>;
};

export const APPS: IAppConfig[] = [
    {
        id: 'DIALER',
        nameLocale: 'APPS_DIALER',
        color: DIALER_APP_TEXT_COLOR,
        path: '/phone',
        home: true,
        Route: () => <AppRoute id="DIALER" path="/phone" component={DialerApp} emitOnOpen={false}/>,
    },
    {
        id: 'MESSAGES',
        nameLocale: 'APPS_MESSAGES',
        color: MESSAGES_APP_TEXT_COLOR,
        path: '/messages',
        home: true,
        Route: () => (
            <AppRoute id="MESSAGES" path="/messages" component={MessagesApp} emitOnOpen={false}/>
        ),
    },
    {
        id: 'CONTACTS',
        nameLocale: 'APPS_CONTACTS',
        color: CONTACTS_APP_TEXT_COLOR,
        path: '/contacts',
        home: true,
        Route: () => (
            <AppRoute id="CONTACTS" path="/contacts" component={ContactsApp} emitOnOpen={false}/>
        ),
    },
    {
        id: 'BANK',
        nameLocale: 'APPS_BANK',
        color: 'common.white',
        path: '/bank',
        Route: () => <AppRoute id="BANK" path="/bank" component={BankApp} emitOnOpen={false}/>,
    },
    {
        id: 'NOTES',
        nameLocale: 'APPS_NOTES',
        color: NOTES_APP_ICON_COLOR,
        path: '/notes',
        Route: () => <AppRoute id="NOTES" path="/notes" component={NotesApp} emitOnOpen={true}/>,
    },
    {
        id: 'SOCIETY_CONTACTS',
        nameLocale: 'APPS_SOCIETY_CONTACTS',
        color: SOCIETY_CONTACTS_APP_TEXT_COLOR,
        path: '/society-contacts',
        Route: () => (
            <AppRoute id="SOCIETY_CONTACTS" path="/society-contacts" component={SocietyContactsApp} emitOnOpen={false}/>
        ),
    },
    {
        id: 'PHOTO',
        nameLocale: 'APPS_PHOTO',
        color: 'common.white',
        path: '/photo',
        Route: () => <AppRoute id="PHOTO" path="/photo" component={PhotoApp} emitOnOpen={true}/>,
    },
    {
        id: 'SETTINGS',
        nameLocale: 'APPS_SETTINGS',
        color: 'grey[50]',
        path: '/settings',
        Route: () => (
            <AppRoute id="SETTINGS" path="/settings" component={SettingsApp} emitOnOpen={false}/>
        ),
    },
    {
        id: 'SOCIETY_MESSAGES',
        nameLocale: 'APPS_SOCIETY_MESSAGES',
        color: SOCIETY_MESSAGES_APP_TEXT_COLOR,
        path: '/society-messages',
        Route: () => (
            <AppRoute id="SOCIETY_MESSAGES" path="/society-messages" component={SocietyMessagesApp} emitOnOpen={false}/>
        ),
    },
    /*{
      id: 'MARKETPLACE',
      nameLocale: 'APPS_MARKETPLACE',
      color: MARKETPLACE_APP_ICON_COLOR,
      path: '/marketplace',
      Route: () => (
        <AppRoute id="MARKETPLACE" path="/marketplace" component={MarketplaceApp} emitOnOpen={false} />
      ),
    },*/
    {
        id: 'CAMERA',
        nameLocale: 'APPS_CAMERA',
        color: 'common.white',
        path: '/camera',
        home: true,
        Route: () => <AppRoute id="CAMERA" path="/camera" component={CameraApp} emitOnOpen={true}/>,
    },
];

// Example app only in dev
if (process.env.NODE_ENV === 'development') {
    APPS.push({
        id: 'EXAMPLE',
        nameLocale: 'APPS_EXAMPLE',
        color: 'blue[50]',
        path: '/example',
        Route: () => (
            <AppRoute id="EXAMPLE" path="/example" component={ExampleAppWrapper} emitOnOpen={false}/>
        ),
    });
}
