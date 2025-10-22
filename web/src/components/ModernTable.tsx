import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  ChevronDown, 
  ChevronUp, 
  Search, 
  Filter, 
  MoreVertical,
  Edit,
  Trash2,
  Eye,
  CheckCircle,
  XCircle,
  Clock,
  AlertCircle
} from 'lucide-react';
import { TableRowActions } from './ActionButton';
import { useNotificationHelpers } from './NotificationProvider';
import ModernModal from './ModernModal';

interface Column {
  key: string;
  label: string;
  sortable?: boolean;
  render?: (value: any, row: any) => React.ReactNode;
  width?: string;
}

interface ModernTableProps {
  data: any[];
  columns: Column[];
  onEdit?: (row: any) => void;
  onDelete?: (row: any) => void;
  onView?: (row: any) => void;
  onMore?: (row: any) => void;
  loading?: boolean;
  emptyMessage?: string;
  searchable?: boolean;
  filterable?: boolean;
  selectable?: boolean;
  onSelectionChange?: (selectedRows: any[]) => void;
  className?: string;
}

const ModernTable: React.FC<ModernTableProps> = ({
  data,
  columns,
  onEdit,
  onDelete,
  onView,
  onMore,
  loading = false,
  emptyMessage = 'Aucune donnée disponible',
  searchable = true,
  filterable = true,
  selectable = false,
  onSelectionChange,
  className = ''
}) => {
  const [sortColumn, setSortColumn] = useState<string | null>(null);
  const [sortDirection, setSortDirection] = useState<'asc' | 'desc'>('asc');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRows, setSelectedRows] = useState<any[]>([]);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [rowToDelete, setRowToDelete] = useState<any>(null);
  const { success, error } = useNotificationHelpers();

  const handleSort = (columnKey: string) => {
    if (sortColumn === columnKey) {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      setSortColumn(columnKey);
      setSortDirection('asc');
    }
  };

  const filteredData = data.filter(row => {
    if (!searchQuery) return true;
    return columns.some(column => {
      const value = row[column.key];
      return value && value.toString().toLowerCase().includes(searchQuery.toLowerCase());
    });
  });

  const sortedData = [...filteredData].sort((a, b) => {
    if (!sortColumn) return 0;
    
    const aValue = a[sortColumn];
    const bValue = b[sortColumn];
    
    if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
    if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
    return 0;
  });

  const handleSelectRow = (row: any) => {
    if (!selectable) return;
    
    const isSelected = selectedRows.some(selected => selected.id === row.id);
    let newSelection;
    
    if (isSelected) {
      newSelection = selectedRows.filter(selected => selected.id !== row.id);
    } else {
      newSelection = [...selectedRows, row];
    }
    
    setSelectedRows(newSelection);
    onSelectionChange?.(newSelection);
  };

  const handleSelectAll = () => {
    if (!selectable) return;
    
    const allSelected = selectedRows.length === sortedData.length;
    const newSelection = allSelected ? [] : [...sortedData];
    
    setSelectedRows(newSelection);
    onSelectionChange?.(newSelection);
  };

  const handleDeleteClick = (row: any) => {
    setRowToDelete(row);
    setShowDeleteModal(true);
  };

  const handleDeleteConfirm = () => {
    if (rowToDelete && onDelete) {
      onDelete(rowToDelete);
      success('Suppression réussie', 'L\'élément a été supprimé avec succès');
    }
    setShowDeleteModal(false);
    setRowToDelete(null);
  };

  const getStatusIcon = (status: string) => {
    switch (status?.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'success':
        return <CheckCircle className="w-4 h-4 text-green-500" />;
      case 'inactive':
      case 'cancelled':
      case 'error':
        return <XCircle className="w-4 h-4 text-red-500" />;
      case 'pending':
      case 'waiting':
        return <Clock className="w-4 h-4 text-yellow-500" />;
      default:
        return <AlertCircle className="w-4 h-4 text-gray-500" />;
    }
  };

  if (loading) {
    return (
      <div className="modern-table-container">
        <div className="table-loading">
          <div className="loading-spinner"></div>
          <p>Chargement des données...</p>
        </div>
      </div>
    );
  }

  return (
    <div className={`modern-table-container ${className}`}>
      {/* Table Controls */}
      {(searchable || filterable || selectable) && (
        <div className="table-controls">
          {searchable && (
            <div className="table-search">
              <Search className="w-4 h-4 search-icon" />
              <input
                type="text"
                placeholder="Rechercher..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="search-input"
              />
            </div>
          )}
          
          {filterable && (
            <button className="btn btn-secondary btn-sm">
              <Filter className="w-4 h-4" />
              Filtres
            </button>
          )}
          
          {selectable && selectedRows.length > 0 && (
            <div className="selection-info">
              {selectedRows.length} élément(s) sélectionné(s)
            </div>
          )}
        </div>
      )}

      {/* Table */}
      <div className="table-wrapper">
        <table className="modern-table">
          <thead>
            <tr>
              {selectable && (
                <th className="select-column">
                  <input
                    type="checkbox"
                    checked={selectedRows.length === sortedData.length && sortedData.length > 0}
                    onChange={handleSelectAll}
                    className="select-checkbox"
                  />
                </th>
              )}
              {columns.map((column) => (
                <th
                  key={column.key}
                  className={column.sortable ? 'sortable' : ''}
                  style={{ width: column.width }}
                  onClick={() => column.sortable && handleSort(column.key)}
                >
                  <div className="th-content">
                    <span>{column.label}</span>
                    {column.sortable && (
                      <div className="sort-indicators">
                        {sortColumn === column.key ? (
                          sortDirection === 'asc' ? (
                            <ChevronUp className="w-4 h-4 sort-active" />
                          ) : (
                            <ChevronDown className="w-4 h-4 sort-active" />
                          )
                        ) : (
                          <div className="sort-placeholder">
                            <ChevronUp className="w-3 h-3" />
                            <ChevronDown className="w-3 h-3" />
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                </th>
              ))}
              {(onEdit || onDelete || onView || onMore) && (
                <th className="actions-column">Actions</th>
              )}
            </tr>
          </thead>
          <tbody>
            {sortedData.length === 0 ? (
              <tr>
                <td colSpan={columns.length + (selectable ? 1 : 0) + ((onEdit || onDelete || onView || onMore) ? 1 : 0)}>
                  <div className="empty-state">
                    <AlertCircle className="w-8 h-8" />
                    <p>{emptyMessage}</p>
                  </div>
                </td>
              </tr>
            ) : (
              sortedData.map((row, index) => (
                <motion.tr
                  key={row.id || index}
                  className={`table-row ${selectedRows.some(selected => selected.id === row.id) ? 'selected' : ''}`}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.05 }}
                  onClick={() => selectable && handleSelectRow(row)}
                >
                  {selectable && (
                    <td className="select-column">
                      <input
                        type="checkbox"
                        checked={selectedRows.some(selected => selected.id === row.id)}
                        onChange={() => handleSelectRow(row)}
                        className="select-checkbox"
                        onClick={(e) => e.stopPropagation()}
                      />
                    </td>
                  )}
                  {columns.map((column) => (
                    <td key={column.key}>
                      {column.render ? column.render(row[column.key], row) : (
                        <div className="cell-content">
                          {column.key === 'status' ? (
                            <div className="status-cell">
                              {getStatusIcon(row[column.key])}
                              <span className={`status-text status-${row[column.key]?.toLowerCase()}`}>
                                {row[column.key]}
                              </span>
                            </div>
                          ) : (
                            row[column.key]
                          )}
                        </div>
                      )}
                    </td>
                  ))}
                  {(onEdit || onDelete || onView || onMore) && (
                    <td className="actions-column">
                      <TableRowActions
                        onEdit={() => onEdit?.(row)}
                        onDelete={() => handleDeleteClick(row)}
                        onView={() => onView?.(row)}
                        onMore={() => onMore?.(row)}
                      />
                    </td>
                  )}
                </motion.tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination Info */}
      <div className="table-footer">
        <div className="pagination-info">
          Affichage de {sortedData.length} élément(s) sur {data.length} total
        </div>
      </div>

      {/* Delete Confirmation Modal */}
      <ModernModal
        isOpen={showDeleteModal}
        onClose={() => setShowDeleteModal(false)}
        title="Confirmer la suppression"
        size="sm"
        type="error"
      >
        <div className="confirm-modal-content">
          <p className="confirm-message">
            Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.
          </p>
          <div className="modal-footer">
            <button
              className="btn btn-secondary"
              onClick={() => setShowDeleteModal(false)}
            >
              Annuler
            </button>
            <button
              className="btn btn-danger"
              onClick={handleDeleteConfirm}
            >
              Supprimer
            </button>
          </div>
        </div>
      </ModernModal>
    </div>
  );
};

export default ModernTable;
