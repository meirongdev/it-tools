import type { GlobalThemeOverrides } from 'naive-ui';

export const lightThemeOverrides: GlobalThemeOverrides = {
  common: {
    primaryColor: '#3a7bd5FF',
    primaryColorHover: '#5a95e5FF',
    primaryColorPressed: '#2a5bb5FF',
    primaryColorSuppl: '#5a95e5FF',
    borderRadius: '4px',
  },

  Menu: {
    itemHeight: '32px',
  },

  Layout: { color: '#f5f5f5' },

  AutoComplete: {
    peers: {
      InternalSelectMenu: { height: '500px' },
    },
  },
};

export const darkThemeOverrides: GlobalThemeOverrides = {
  common: {
    primaryColor: '#5a95e5FF',
    primaryColorHover: '#7aafe8FF',
    primaryColorPressed: '#3a7bd5FF',
    primaryColorSuppl: '#7aafe8FF',
    borderRadius: '4px',
    bodyColor: '#1a1b26',
  },

  Notification: {
    color: '#252637',
  },

  AutoComplete: {
    peers: {
      InternalSelectMenu: { height: '500px', color: '#1a1b26' },
    },
  },

  Menu: {
    itemHeight: '32px',
    color: '#21223a',
    itemTextColor: '#c0caf5',
    itemTextColorActive: '#7aafe8',
    itemTextColorHover: '#7aafe8',
    itemColorActive: '#2a2c45',
    itemColorHover: '#252637',
  },

  Layout: {
    color: '#1a1b26',
    siderColor: '#21223a',
    siderBorderColor: 'transparent',
  },

  Card: {
    color: '#21223a',
    borderColor: '#2a2c45',
  },

  Table: {
    tdColor: '#21223a',
    thColor: '#2a2c45',
  },
};
